//
//  Articles+CoreDataClass.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Oct/17/20.
//  Copyright © 2020 Daniel Marco S. Rafanan. All rights reserved.
//
//

import Foundation
import CoreData

public class Article: NSManagedObject, Decodable {
  
    required convenience public init(from decoder: Decoder) throws {
        
        enum CodingKeys:String, CodingKey{
            case articleDescription = "description"
            case publishedAt
            case title
            case url
            case urlToImage
            case source
        }

        self.init(entity:Article.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        title       = try container.decodeIfPresent(String.self, forKey: .title)
        publishedAt = try container.decodeIfPresent(String.self, forKey: .publishedAt)
        url         = try container.decodeIfPresent(String.self, forKey: .url)
        urlToImage  = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        articleDescription = try container.decodeIfPresent(String.self, forKey: .articleDescription)
        source      = try container.decodeIfPresent(Source.self, forKey: .source)
    }
    
    func createCopy(on container:NSPersistentContainer) {
        let context = container.viewContext
        let copy = Article(context: context)
        copy.articleDescription = articleDescription
        copy.publishedAt = publishedAt
        copy.title = title
        copy.url = url
        copy.urlToImage = urlToImage
        let newSource = Source(context: container.viewContext)
        newSource.sourceId = source?.sourceId
        newSource.name = source?.name
        copy.source = newSource
    }
}
