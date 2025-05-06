//
//  Anime.swift
//  
//
//  Created by alexis on 2022/8/3.
//

import Foundation

public struct Anime: Codable, Hashable {
    
    public let animeId: Int
    public let animeTitle: String?
    public let type: String?
    public let episodes: [Episode]?
}
