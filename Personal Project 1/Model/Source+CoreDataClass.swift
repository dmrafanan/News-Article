//
//  Source+CoreDataClass.swift
//  Personal Project 1
//
//  Created by Daniel Marco S. Rafanan on Feb/5/21.
//  Copyright © 2021 Daniel Marco S. Rafanan. All rights reserved.
//
//

import Foundation
import CoreData


public class Source: NSManagedObject,Decodable {
    required convenience public init(from decoder: Decoder) throws {
        
        enum CodingKeys:String, CodingKey{
            case name
            case sourceId

        }

        self.init(entity:Source.entity(), insertInto: nil)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name     = try container.decodeIfPresent(String.self, forKey: .name)
        sourceId = try container.decodeIfPresent(String.self, forKey: .sourceId)
    }
}
