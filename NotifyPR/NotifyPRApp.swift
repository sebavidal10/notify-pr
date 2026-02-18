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
        // 1. La Barra de Menú (El Popover)
        MenuBarExtra {
            VStack(spacing: 0) {
                // Cabecera
                HStack {
                    Text("Pull Requests")
                        .font(.headline)
                    Spacer()
                    if store.isLoading {
                        ProgressView().controlSize(.small)
                    } else {
                        Button(action: { Task { await store.fetchPRs() } }) {
                            Image(systemName: "arrow.clockwise")
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
                
                Divider()
                
                // Lista
                if store.prs.isEmpty {
                    Text("Todo al día ☕️")
                        .padding()
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(store.prs) { pr in
                                HStack {
                                    AsyncImage(url: URL(string: pr.user.avatar_url)) { image in
                                        image.resizable()
                                    } placeholder: {
                                        Color.gray
                                    }
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                                    
                                    VStack(alignment: .leading) {
                                        Text(pr.title)
                                            .font(.system(size: 12))
                                            .lineLimit(1)
                                        Text(pr.user.login)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    store.openPR(pr.url)
                                }
                            }
                        }
                        .padding(.vertical)
                    }
                    .frame(maxHeight: 300)
                }
                
                Divider()
                
                // Footer
                HStack {
                    if #available(macOS 14.0, *) {
                        SettingsLink { Image(systemName: "gear") }
                            .buttonStyle(.plain)
                    } else {
                        Button(action: {
                            NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                            NSApp.activate(ignoringOtherApps: true)
                        }) {
                            Image(systemName: "gear")
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Spacer()
                    
                    Button("Salir") {
                        NSApplication.shared.terminate(nil)
                    }
                    .buttonStyle(.plain)
                    .font(.caption)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
            }
            .frame(width: 300)
            
        } label: {
            HStack(spacing: 4) {
               if let originalImage = NSImage(named: "gatipulpo") {
                    let _ = originalImage.isTemplate = true
                    Image(nsImage: originalImage).renderingMode(.template)
                }
                
                if store.isLoading {
                    ProgressView().controlSize(.small).frame(width: 12, height: 12)
                } else if store.prs.count > 0 {
                    Text("\(store.prs.count)").font(.system(size: 12, weight: .bold))
                }
            }
        }
        .menuBarExtraStyle(.window) // Estilo Popover

        // 2. La Ventana de Configuración (¡ESTO FALTABA!)
        Settings {
            SettingsView()
        }
    }
}
