//
//  Comment.swift
//  
//
//  Created by alexis on 2022/8/3.
//

import Foundation

public struct Comment: Codable, Hashable {

    public enum Position: Int, Codable {
        case normal = 1
        case bottom = 4
        case top = 5
    }
    
    public enum CodingKeys: String, CodingKey {
        case cid
        case param = "p"
        case message = "m"
    }
    
    public let cid: Int
    public let param: String
    public let message: String
    
    public let time: Double
    public let position: Position
    public let hex: Int
    public let uid: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.cid = try container.decode(Int.self, forKey: .cid)
        self.param = try container.decode(String.self, forKey: .param)
        self.message = try container.decode(String.self, forKey: .message)
        let components = param.components(separatedBy: ",")
        if components.count == 4 {
            self.time = Double(components[0]) ?? 0
            self.position = Position(rawValue: Int(components[1]) ?? 1) ?? .top
            self.hex = Int(components[2]) ?? 0
            self.uid = components[3]
        } else {
            throw NSError(domain: "", code: -1)
        }
    }
    
    public init(param: String, text: String) throws {
        /// https://www.bilibili.com/read/cv6189156/
        self.param = param
        self.message = text
        let components = param.components(separatedBy: ",")
        if components.count >= 8 {
            
//            let time = components[0]
//            let type = components[1]
//            let size = components[2]
//            let color = components[3]
//            let timestamp = components[4]
//            let pool = components[5]
//            let uid = components[6]
//            let rowid = components[7]
            
            self.time = Double(components[0]) ?? 0
            self.cid = Int(components[7]) ?? 0
            self.hex = Int(components[3]) ?? 0
            self.uid = components[6]
            self.position = .top
        } else if components.count == 5 {
            //<d p="{time_format},{style},{font_size},{default_num},{id}">{content}</d>
            self.time = Double(components[0]) ?? 0
            self.cid = 0
            self.hex = Int(components[3]) ?? 16777215
            self.uid = "0"
            self.position = .top
        } else {
            print(components.count)
            throw NSError(domain: "", code: -1)
        }
    }
}
