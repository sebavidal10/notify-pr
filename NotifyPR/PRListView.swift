//
//  PRListView.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import SwiftUI

struct PRListView: View {
    @ObservedObject var store: PRStore
    
    var body: some View {
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
                let calculatedHeight = min(CGFloat(store.prs.count) * 50 + 20, 320)
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
                .frame(height: calculatedHeight)
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
