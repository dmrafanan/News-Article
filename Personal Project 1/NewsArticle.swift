//
//  NewsArticle.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Sep/13/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//

import Foundation
struct Response:Codable {
    var status:String?
    var totalResults:Int?
    var articles:[Article]?
}

struct Article:Codable {
    var source:Source?
    var author:String?
    var title:String?
    var description:String?
    var url:String?
    var urlToImage:String?
    var publishedAt:String?
    var content:String?
}

struct Source:Codable {
    var id:String?
    var name:String?
}
