//
//  SearchEpisodeResponse.swift
//  
//
//  Created by alexis on 2022/8/3.
//

import Foundation

public struct SearchEpisodeResponse: Codable {
    public let animes: [Anime]?
    public let errorCode: Int?
    public let success: Bool?
    public let errorMessage: String?
}
