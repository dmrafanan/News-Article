//
//  Network.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Oct/3/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation
import CoreData
import Alamofire

class NetworkManager{
    static let shared = NetworkManager()
    let baseURL = "http://newsapi.org/v2/top-headlines?country=ph&pageSize=40&apiKey=3e6efed2c0614492b40a7d7b716289b5"
    
    private init() {}
    
    var isFetching = false
    func fetchArticles(withParameters parameters:String? = nil,completionHandler:@escaping (Result<[Article],GetArticlesError>) -> Void){
        isFetching = true
        var endPoint = baseURL
        if let _ = parameters{
            endPoint = "http://newsapi.org/v2/everything?pageSize=100\(parameters!)&apiKey=3e6efed2c0614492b40a7d7b716289b5"
        }
        guard let url = URL(string: endPoint) else{
            completionHandler(.failure(.error))
            return
        }
        AF.request(url, method: .get).validate().responseData{ response in
            switch response.result{
            case .failure(_):
                completionHandler(.failure(.error))
            case .success(let data):
                DispatchQueue.main.async {
                    do{
                        let jsonObject = try JSONSerialization.jsonObject(with: data , options: []) as? [String:Any]
                        let articlesFromJsonObject = jsonObject!["articles"]!
                        let JSONOfArticlesOnly = try JSONSerialization.data(withJSONObject: articlesFromJsonObject, options: [])
                        
                        let articles = try! JSONDecoder().decode(Array<Article>.self, from: JSONOfArticlesOnly)
                        completionHandler(.success(articles))
                        self.isFetching = false
                    }catch{
                        completionHandler(.failure(.error))
                        self.isFetching = false
                    }
                }
            }
            
        }
    }
}

enum GetArticlesError: String, Error {
    case error = "Error"
}
