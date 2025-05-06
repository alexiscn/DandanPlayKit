//
//  Match.swift
//  
//
//  Created by alexis on 2022/8/3.
//

import Foundation

public struct Match: Codable, Hashable {
    public let episodeId: Int?
    public let animeId: Int?
    public let animeTitle: String?
    public let episodeTitle: String?
    public let type: String?
    public let typeDescription: String?
    public let shift: Double?
}
