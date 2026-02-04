//
//  LaunchManager.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import Foundation
import ServiceManagement
import SwiftUI
import Combine // Necesario para que @Published y ObservableObject funcionen correctamente

class LaunchManager: ObservableObject {
    // La forma correcta de acceder al servicio de la app principal
    private let service: SMAppService = .mainApp
    
    @Published var launchAtLogin: Bool {
        didSet {
            do {
                if launchAtLogin {
                    try service.register()
                    print("🚀 Gatipulpo registrado para iniciar al login")
                } else {
                    try service.unregister()
                    print("🛑 Gatipulpo eliminado del inicio automático")
                }
            } catch {
                print("❌ Error al cambiar Launch at Login: \(error)")
                // Revertimos el estado visual si falla la operación de sistema
                DispatchQueue.main.async {
                    self.launchAtLogin = (self.service.status == .enabled)
                }
            }
        }
    }

    init() {
        // Inicializamos consultando el estado real del sistema
        self.launchAtLogin = (SMAppService.mainApp.status == .enabled)
    }
}
