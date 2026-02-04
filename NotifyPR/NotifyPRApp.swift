//
//  NotifyPRApp.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import SwiftUI

@main
struct NotifyPRApp: App {
    @StateObject private var store = PRStore()

    var body: some Scene {
        MenuBarExtra {
            if store.isLoading {
                Text("Cargando PRs...")
            } else if store.prs.isEmpty {
                Text("Todo al día ☕️")
            } else {
                Text("PRs pendientes por revisar:")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Listado de PRs
                ForEach(store.prs) { pr in
                    Button("\(pr.user.login): \(pr.title)") {
                        store.openPR(pr.url)
                    }
                }
            }

            Divider()
                
            // En lugar de un Button { SettingsLink... }, usa esto directamente:
            if #available(macOS 14.0, *) {
                SettingsLink {
                    Text("Configuración...")
                }
            } else {
                Button("Configuración...") {
                    NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    NSApp.activate(ignoringOtherApps: true)
                }
            }
            
            Divider()

            Button("Actualizar ahora") {
                Task { await store.fetchPRs() }
            }
            
            Button("Salir") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            HStack(spacing: 4) {
                if let originalImage = NSImage(named: "gatipulpo") {
                    let _ = originalImage.isTemplate = true // Esto hace que cambie de color solo
                    Image("gatipulpo")
                        .renderingMode(.template)
                }
                
                if store.prs.count > 0 {
                    Text("\(store.prs.count)")
                        .font(.system(size: 12, weight: .bold))
                }
            }
        }
        
        Settings {
            SettingsView()
        }
    }
}
