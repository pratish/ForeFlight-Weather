//
//  MOS.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation

public struct MOS: Codable {
   
    public var station: String?
    public var issued: String?
    
    public init() {
        
    }
    
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.station = try container.decode(String.self, forKey: .station)
//        self.issued = try container.decode(String.self, forKey: .issued)
//    }
}
