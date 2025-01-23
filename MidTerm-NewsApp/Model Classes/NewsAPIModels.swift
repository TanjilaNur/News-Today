//
//  File.swift
//  22. News App_MidTerm[12-18]
//
//  Created by BJIT on 12/1/23.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let status: String
    let totalResults: Int
    let articles: [ArticleModel]
}

// MARK: - Article
struct APIResponse: Codable {
    let articles: [ArticleModel]
}

// MARK: - ArticleModel
struct ArticleModel: Codable {
    let source: Source
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String?
}

//New Categories
enum CategoryList:String, CaseIterable {
    case all, general, business,entertainment,health,science,sports,technology
}
