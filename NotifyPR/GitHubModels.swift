//
//  GitHubModels.swift
//  NotifyPR
//
//  Created by Sebastián Vidal Aedo on 04-02-26.
//

import Foundation

// Lo que nos devuelve GitHub al buscar
struct GitHubSearchResponse: Codable {
    let total_count: Int
    let items: [PullRequest]
}

// Los detalles de cada PR
struct PullRequest: Codable, Identifiable {
    let id: Int
    let title: String
    let html_url: String
    let user: GitHubUser
    
    // Para que SwiftUI sepa cuál es cuál en la lista
    var url: URL? { URL(string: html_url) }
}

struct GitHubUser: Codable {
    let login: String
    let avatar_url: String
}
