//
//  SettingsView.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import SwiftUI

struct GeneralSettingsView: View {
    @StateObject private var launchManager = LaunchManager()
    @AppStorage("refresh_interval") private var refreshInterval = 5.0
    @AppStorage("default_browser") private var defaultBrowser = "default"
    
    #if !APPSTORE
    @AppStorage("auto_update_enabled") private var autoUpdateEnabled = true
    #endif

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                #if !APPSTORE
                Section(header: Text("Actualizaciones").font(.headline)) {
                    Toggle("Buscar actualizaciones automáticamente", isOn: $autoUpdateEnabled)
                        .toggleStyle(.switch)
                    
                    Button("Buscar ahora...") {
                        checkForUpdates()
                    }
                    .controlSize(.small)
                }
                #endif
                
                Section(header: Text("Comportamiento").font(.headline)) {
                    Picker("Refrescar cada:", selection: $refreshInterval) {
                        Text("1 minuto").tag(1.0)
                        Text("5 minutos").tag(5.0)
                        Text("15 minutos").tag(15.0)
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 250)
                    
                    Toggle("Iniciar al arrancar el Mac", isOn: $launchManager.launchAtLogin)
                        .toggleStyle(.switch)
                }
                
                Section(header: Text("Navegador").font(.headline).padding(.top, 10)) {
                    Picker("Abrir enlaces con:", selection: $defaultBrowser) {
                        Text("Por defecto del sistema").tag("default")
                        Text("Safari").tag("com.apple.Safari")
                        Text("Google Chrome").tag("com.google.Chrome")
                        Text("Arc").tag("company.thebrowser.Browser")
                        Text("Brave").tag("com.brave.Browser")
                        Text("Firefox").tag("org.mozilla.firefox")
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 300)
                }
            }
            .formStyle(.grouped)
            
            Spacer()
        }
        .padding(.top, 10)
    }
    
    #if !APPSTORE
    func checkForUpdates() {
        guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }
        
        let url = URL(string: "https://api.github.com/repos/sebavidal10/notify-pr/releases/latest")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let latestVersionTag = json["tag_name"] as? String {
                    
                    let latestVersion = latestVersionTag.replacingOccurrences(of: "v", with: "")
                    
                    DispatchQueue.main.async {
                        let alert = NSAlert()
                        
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
    #endif
}

struct GitHubSettingsView: View {
    @AppStorage("gh_token") private var token = ""
    @AppStorage("gh_user") private var username = ""
    @AppStorage("is_demo_mode") private var isDemoMode = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Form {
                Section(header: Text("Cuenta de GitHub").font(.headline)) {
                    TextField("Usuario:", text: $username, prompt: Text("Tu usuario"))
                    SecureField("Token:", text: $token, prompt: Text("ghp_..."))
                }
                
                Section(header: Text("Revisión de Apple").font(.headline)) {
                    Toggle("Modo Demostración", isOn: $isDemoMode)
                        .toggleStyle(.switch)
                    Text("Activa esto para ver datos de prueba si no tienes una cuenta de GitHub configurada.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .formStyle(.grouped)
            .textFieldStyle(.roundedBorder)
            
            Spacer()
        }
        .padding(.top, 10)
    }
}

struct AboutSettingsView: View {
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            if let appIcon = NSImage(named: NSImage.Name("AppIcon")) {
                Image(nsImage: appIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else if let bundleIcon = NSImage(named: NSImage.applicationIconName) {
                Image(nsImage: bundleIcon)
                    .resizable()
                    .frame(width: 80, height: 80)
            } else {
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
}
