//
//  PRStore.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications
import ServiceManagement

enum TokenStatus {
    case none
    case valid
    case invalid
    case checking
    case expired
}

@MainActor
class PRStore: ObservableObject {
    @Published var prs: [PullRequest] = []
    @Published var isLoading = false
    @Published var tokenStatus: TokenStatus = .none
    @AppStorage("is_demo_mode") private var isDemoMode = false
    
    private var lastPRCount: Int = 0
    private var timer: Timer?
    
    // El token ahora se maneja vía KeychainHelper
    var token: String {
        get { KeychainHelper.shared.read() ?? "" }
        set { 
            KeychainHelper.shared.save(newValue)
            Task { await validateToken() }
        }
    }
    
    var username: String {
        get { UserDefaults.standard.string(forKey: "gh_user") ?? "" }
        set { 
            UserDefaults.standard.set(newValue, forKey: "gh_user")
            Task { await fetchPRs() }
        }
    }
    
    private var refreshInterval: Double {
        let interval = UserDefaults.standard.double(forKey: "refresh_interval")
        return interval > 0 ? interval : 5.0
    }
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                print("✅ Permiso de notificaciones concedido")
            }
        }
        
        Task {
            await validateToken()
            await fetchPRs()
            setupTimer()
        }
        
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                // Solo re-fetch si no estamos en medio de una carga
                if !self.isLoading {
                    await self.fetchPRs()
                    self.setupTimer()
                }
            }
        }
    }
    
    func setupTimer() {
        timer?.invalidate()
        let seconds = refreshInterval * 60.0
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.fetchPRs()
            }
        }
    }

    func validateToken() async {
        guard !token.isEmpty else {
            tokenStatus = .none
            return
        }
        
        tokenStatus = .checking
        
        guard let url = URL(string: "https://api.github.com/user") else { return }
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    tokenStatus = .valid
                } else if httpResponse.statusCode == 401 {
                    tokenStatus = .invalid
                } else {
                    tokenStatus = .none
                }
            }
        } catch {
            print("❌ Error validando token: \(error)")
            tokenStatus = .none
        }
    }

    func sendNotification(title: String, subtitle: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.sound = .default

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }
    
    func fetchPRs() async {
        guard !isLoading else { return }
        isLoading = true
        
        if isDemoMode {
            await simulateFetch()
            isLoading = false
            return
        }
        
        guard !token.isEmpty, !username.isEmpty else {
            isLoading = false
            return
        }
        
        let query = "is:open+is:pr+review-requested:\(username)"
        guard let url = URL(string: "https://api.github.com/search/issues?q=\(query)") else {
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    tokenStatus = .expired
                    isLoading = false
                    return
                }
            }
            
            let searchResponse = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
            let newCount = searchResponse.total_count
            
            if newCount > lastPRCount {
                sendNotification(
                    title: "¡Nuevo PR asignado!",
                    subtitle: "Tienes \(newCount) tareas pendientes en total."
                )
            }
            
            self.prs = searchResponse.items
            self.lastPRCount = newCount
            tokenStatus = .valid
            
        } catch {
            print("❌ Error al obtener PRs: \(error)")
        }
        isLoading = false
    }
    
    private func simulateFetch() async {
        let mockUser1 = GitHubUser(login: "apple_reviewer", avatar_url: "https://github.com/apple.png")
        let mockUser2 = GitHubUser(login: "sebavidal", avatar_url: "https://github.com/sebavidal10.png")
        
        let mockPRs = [
            PullRequest(id: 1, title: "[DEMO] Corregir error de navegación", html_url: "https://github.com", user: mockUser1),
            PullRequest(id: 2, title: "[DEMO] Implementar modo oscuro", html_url: "https://github.com", user: mockUser2),
            PullRequest(id: 3, title: "[DEMO] Actualizar documentación de API", html_url: "https://github.com", user: mockUser1)
        ]
        
        try? await Task.sleep(nanoseconds: 500_000_000)
        self.prs = mockPRs
        self.lastPRCount = mockPRs.count
    }
    
    func openPR(_ url: URL?) {
        guard let url = url else { return }
        let browser = UserDefaults.standard.string(forKey: "default_browser") ?? "default"
        
        if browser == "default" {
            NSWorkspace.shared.open(url)
        } else if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: browser) {
            let configuration = NSWorkspace.OpenConfiguration()
            NSWorkspace.shared.open([url], withApplicationAt: appURL, configuration: configuration, completionHandler: nil)
        } else {
            NSWorkspace.shared.open(url)
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

