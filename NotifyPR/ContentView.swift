//
//  ContentView.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var store: PRStore
    @State private var selectedTab: Tab = .prList
    
    enum Tab {
        case prList
        case general
        case github
        case about
    }

    var body: some View {
        VStack(spacing: 0) {
            // Main Content Area
            Group {
                switch selectedTab {
                case .prList:
                    PRListView(store: store)
                case .general:
                    GeneralSettingsView()
                case .github:
                    GitHubSettingsView()
                case .about:
                    AboutSettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Divider()
            
            // Custom Bottom Navigation Bar
            bottomNavBar
        }
        .frame(width: 320, height: 460) // Ajuste de tamaño para el nuevo diseño
    }
    
    private var bottomNavBar: some View {
        HStack(spacing: 12) {
            navButton(icon: "list.bullet", tab: .prList)
            navButton(icon: "gearshape.fill", tab: .general)
            navButton(icon: "lock.fill", tab: .github)
            navButton(icon: "info.circle.fill", tab: .about)
            
            Spacer()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Image(systemName: "power")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.red)
                    .frame(width: 36, height: 36)
                    .background(Color.gray.opacity(0.15))
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.darkGray).opacity(0.1)) // Fondo sutil para la barra
    }
    
    private func navButton(icon: String, tab: Tab) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) {
                selectedTab = tab
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(selectedTab == tab ? .white : .secondary)
                .frame(width: 36, height: 36)
                .background(selectedTab == tab ? Color.accentColor : Color.gray.opacity(0.15))
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
