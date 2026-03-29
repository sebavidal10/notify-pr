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
        // La Barra de Menú (El Popover con Tabs integrados)
        MenuBarExtra {
            ContentView(store: store)
        } label: {
            HStack(spacing: 4) {
               if let originalImage = NSImage(named: "gatipulpo") {
                    Image(nsImage: {
                        let img = originalImage
                        img.isTemplate = true
                        return img
                    }())
                    .renderingMode(.template)
                }
                
                ZStack {
                    ProgressView()
                        .controlSize(.small)
                        .frame(width: 12, height: 12)
                        .opacity(store.isLoading ? 1 : 0)
                    
                    Text("\(store.prs.count)")
                        .font(.system(size: 12, weight: .bold))
                        .opacity((!store.isLoading && store.prs.count > 0) ? 1 : 0)
                }
            }
        }
        .menuBarExtraStyle(.window) // Estilo Popover
    }
}
