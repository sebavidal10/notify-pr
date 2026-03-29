//
//  PRStore.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import Foundation
import SwiftUI // ObservableObject vive aquí (o en Combine)
import Combine
import UserNotifications
import ServiceManagement

@MainActor
class PRStore: ObservableObject {
    @Published var prs: [PullRequest] = []
    @Published var isLoading = false
    @AppStorage("is_demo_mode") private var isDemoMode = false
    
    private var lastPRCount: Int = 0
    private var timer: Timer?
    
    // Leemos directamente de UserDefaults
    var token: String { UserDefaults.standard.string(forKey: "gh_token") ?? "" }
    var username: String { UserDefaults.standard.string(forKey: "gh_user") ?? "" }
    
    // Obtenemos la frecuencia guardada (por defecto 5 min si no existe)
    private var refreshInterval: Double {
        let interval = UserDefaults.standard.double(forKey: "refresh_interval")
        return interval > 0 ? interval : 5.0
    }
    
    init() {
        // 1. Pedir permiso para notificaciones (AppKit maneja esto en segundo plano)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("✅ Permiso de notificaciones concedido")
            }
        }
        
        // 2. Tareas que requieren el hilo principal (MainActor)
        // Usamos una sola Task para evitar crear múltiples hilos innecesarios
        Task { @MainActor in
            // Carga inicial y configuración del timer
            await fetchPRs()
            setupTimer()
        }
        
        // 3. Observador consolidado
        // No necesitas dos observadores para la misma notificación
        NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                guard let self = self else { return }
                await self.fetchPRs() // Refresca datos
                self.setupTimer()     // Reinicia el timer con la nueva frecuencia
            }
        }
    }
    
    func setupTimer() {
        timer?.invalidate()
        
        let seconds = refreshInterval * 60.0
        print("🕒 Timer configurado cada \(refreshInterval) minutos (\(seconds)s)")
        
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: true) { [weak self] _ in
            Task {
                await self?.fetchPRs()
            }
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
        isLoading = true
        
        if isDemoMode {
            // Datos de demostración para los revisores de Apple
            let mockUser1 = GitHubUser(login: "apple_reviewer", avatar_url: "https://github.com/apple.png")
            let mockUser2 = GitHubUser(login: "sebavidal", avatar_url: "https://github.com/sebavidal10.png")
            
            let mockPRs = [
                PullRequest(id: 1, title: "[DEMO] Corregir error de navegación", html_url: "https://github.com", user: mockUser1),
                PullRequest(id: 2, title: "[DEMO] Implementar modo oscuro", html_url: "https://github.com", user: mockUser2),
                PullRequest(id: 3, title: "[DEMO] Actualizar documentación de API", html_url: "https://github.com", user: mockUser1)
            ]
            
            try? await Task.sleep(nanoseconds: 500_000_000) // Simular delay
            
            self.prs = mockPRs
            self.lastPRCount = mockPRs.count
            isLoading = false
            return
        }
        
        // Query: PRs abiertos donde se solicita tu revisión
        let query = "is:open+is:pr+review-requested:\(username)"
        guard let url = URL(string: "https://api.github.com/search/issues?q=\(query)") else { return }
        
        var request = URLRequest(url: url)
        request.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let response = try JSONDecoder().decode(GitHubSearchResponse.self, from: data)
            
            let newCount = response.total_count
            
            // SOLO si el número aumentó, mandamos notificación
            if newCount > lastPRCount {
                sendNotification(
                    title: "¡Nuevo PR asignado!",
                    subtitle: "Tienes \(newCount) tareas pendientes en total."
                )
            }
            
            // Actualizamos los estados
            self.prs = response.items
            self.lastPRCount = newCount
            
        } catch {
            print("Error: \(error)")
        }
        isLoading = false
    }
    
    func openPR(_ url: URL?) {
        guard let url = url else { return }
        
        let browser = UserDefaults.standard.string(forKey: "default_browser") ?? "default"
        
        if browser == "default" {
            NSWorkspace.shared.open(url)
        } else {
            if let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: browser) {
                let configuration = NSWorkspace.OpenConfiguration()
                NSWorkspace.shared.open([url], withApplicationAt: appURL, configuration: configuration, completionHandler: nil)
            } else {
                // Fallback si el navegador elegido no está instalado
                NSWorkspace.shared.open(url)
            }
        }
    }
    
    deinit {
        timer?.invalidate()
        print("Recursos liberados y timer detenido.")
    }
}
