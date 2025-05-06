//
//  Episode.swift
//  
//
//  Created by alexis on 2022/8/3.
//

import Foundation

public struct Episode: Codable, Hashable {
    
    public enum CodingKeys: String, CodingKey {
        case id = "episodeId"
        case title = "episodeTitle"
    }
    
    public let id: Int
    public let title: String
    
    public init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
}
