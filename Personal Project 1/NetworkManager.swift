//
//  Network.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Oct/3/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation

struct NetworkManager{
    static let shared = NetworkManager()
    let baseURL = "http://newsapi.org/v2/top-headlines?language=en&pageSize=100&apiKey=3e6efed2c0614492b40a7d7b716289b5"
    
    private init() {}
    
    func getArticles(completionHandler:@escaping (Result<[Article],GetArticlesError>) -> Void){
        let endPoint = baseURL
        guard let url = URL(string: endPoint) else{
            completionHandler(.failure(.error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completionHandler(.failure(.error))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.error))
                return
            }
            guard let data = data else {
                completionHandler(.failure(.error))
                return
            }
            
            
            do{
                let decoder = JSONDecoder()
                let articles = try decoder.decode(Response.self, from: data)
//                completionHandler(.success(articles))1
            }catch{
                completionHandler(.failure(.error))
            }
        }
        task.resume()

    }
}

enum GetArticlesError: String, Error {
    case error = "Error"
}
