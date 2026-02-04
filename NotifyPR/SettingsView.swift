//
//  SettingsView.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var launchManager = LaunchManager()
    @AppStorage("gh_token") private var token = ""
    @AppStorage("gh_user") private var username = ""
    @AppStorage("refresh_interval") private var refreshInterval = 5.0
    @AppStorage("enable_music_mode") private var enableMusicMode = true
    @AppStorage("auto_update_enabled") private var autoUpdateEnabled = true
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"

    var body: some View {
        TabView {
            generalSection
                .tabItem { Label("General", systemImage: "gear") }
            
            githubSection
                .tabItem { Label("GitHub", systemImage: "lock") }
            
            aboutSection
                .tabItem { Label("Acerca de", systemImage: "info.circle") }
        }
        .frame(width: 450, height: 320)
    }

    // MARK: - Sección General
    private var generalSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section(header: Text("Comportamiento").font(.headline)) {
                    Picker("Refrescar cada:", selection: $refreshInterval) {
                        Text("1 minuto").tag(1.0)
                        Text("5 minutos").tag(5.0)
                        Text("15 minutos").tag(15.0)
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 250) // Limita el ancho para que no se estire
                    
                    Toggle("Iniciar al arrancar el Mac", isOn: $launchManager.launchAtLogin)
                        .toggleStyle(.switch)
                }
                
                Section(header: Text("Enfoque").font(.headline).padding(.top, 10)) {
                    Toggle("Viernes de música", isOn: $enableMusicMode)
                        .toggleStyle(.switch)
                    Text("Desactiva notificaciones los viernes de 19:00 a 00:00.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Section(header: Text("Actualizaciones").font(.headline)) {
                    Toggle("Buscar actualizaciones automáticamente", isOn: $autoUpdateEnabled)
                        .toggleStyle(.switch)
                    
                    Button("Buscar ahora...") {
                        checkForUpdates()
                    }
                    .controlSize(.small)
                }
            }
            .formStyle(.grouped) // Mantiene todo ordenado y alineado a la izquierda
            
            Spacer()
        }
    }

    // MARK: - Sección Acerca de
    private var aboutSection: some View {
        VStack(spacing: 15) {
            Spacer()
            
            // Usamos el nombre del Asset directamente
            if let appIcon = NSImage(named: NSImage.Name("AppIcon")) {
                Image(nsImage: appIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else if let bundleIcon = NSImage(named: NSImage.applicationIconName) {
                // Alternativa si el nombre explícito falla
                Image(nsImage: bundleIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
                // Caso de respaldo (un placeholder para que no quede vacío)
                Image(systemName: "app.badge.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 5) {
                Text("NotifyPR")
                    .font(.title2)
                    .bold()
                
                // --- TU CÓDIGO DINÁMICO AQUÍ ---
                let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
                let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
                
                Text("Versión \(appVersion) (Build \(buildNumber))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Divider().frame(width: 200)

            VStack(spacing: 8) {
                Text("Desarrollado por **Sebastián Vidal Aedo**")
                    .font(.body)
                
                Link("GitHub", destination: URL(string: "https://github.com/sebavidal10/notify-pr")!)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
            Text("© 2026 Todos los derechos reservados.")
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .padding(.bottom, 15)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var githubSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section(header: Text("Cuenta de GitHub").font(.headline)) {
                    TextField("Usuario:", text: $username, prompt: Text("Tu usuario"))
                    SecureField("Token:", text: $token, prompt: Text("ghp_..."))
                }
            }
            .formStyle(.grouped)
            .textFieldStyle(.roundedBorder)
            
            Spacer()
        }
    }
    
    func checkForUpdates() {
        // 1. Obtenemos la versión actual del proyecto (ej: "1.0")
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        let url = URL(string: "https://api.github.com/repos/sebavidal10/notify-pr/releases/latest")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                // 2. Parseamos la respuesta de GitHub
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let latestVersionTag = json["tag_name"] as? String {
                    
                    // Limpiamos el tag (por si es "v1.1" convertirlo a "1.1")
                    let latestVersion = latestVersionTag.replacingOccurrences(of: "v", with: "")
                    
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        
                        // 3. Comparación lógica
                        if latestVersion > currentVersion {
                            alert.messageText = "¡Nueva actualización disponible!"
                            alert.informativeText = "La versión \(latestVersionTag) está disponible en GitHub. Tú tienes la \(currentVersion)."
                            alert.addButton(withTitle: "Ver en GitHub")
                            alert.addButton(withTitle: "Más tarde")
                            
                            if alert.runModal() == .alertFirstButtonReturn {
                                if let url = URL(string: "https://github.com/sebavidal10/notify-pr/releases") {
                                    NSWorkspace.shared.open(url)
                                }
                            }
                        } else {
                            alert.messageText = "NotifyPR está al día"
                            alert.informativeText = "Ya tienes la versión más reciente (\(currentVersion))."
                            alert.addButton(withTitle: "OK")
                            alert.runModal()
                        }
                    }
                }
            } catch {
                print("❌ Error al parsear update: \(error)")
            }
        }.resume()
    }
}
