//
//  Conditions.swift
//  ForeFlight Weather
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
public struct Conditions: Codable {
    public var text: String? = nil
    public var ident: String? = nil
    public var dateIssued: String? = nil
    
    public init() {
        
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.ident = try container.decode(String.self, forKey: .ident)
        self.dateIssued = try container.decode(String.self, forKey: .dateIssued)
    }
    
}
