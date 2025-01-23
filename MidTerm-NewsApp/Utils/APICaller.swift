//
//  ApiManager.swift
//  22. News App_MidTerm[12-18]
//
//  Created by BJIT on 12/1/23.
//

import UIKit

final class APICaller {
    static let shared = APICaller()
    let context = Constants.context
    
    private init() {}
    
    struct Constant {
        static let newsURL = "https://newsapi.org/v2/top-headlines?country=us&apiKey=6ca32dc780bc4c648d3e89217e19bc48"
    }
    
    public func fetchDataFromAPI(query: String, category: CategoryList,completion: @escaping (Result<[ArticleModel], Error>) -> Void) {
        
        let news = CoreDataManager.shared.getMatchedRecords(query: query, category: category)
        print(news)
        var urlString = Constant.newsURL
        
        if category != .all {
            urlString.append("&category=\(category.rawValue)")
        }
        print(Constant.newsURL)
        
        guard let url = URL(string:urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles:\(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
                
            }
        }
        task.resume()
    }
}




