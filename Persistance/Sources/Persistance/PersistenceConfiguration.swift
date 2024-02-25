//
//  File.swift
//  
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation

public struct PersistenceConfiguration {
    public init(
        modelName: String,
        cloudIdentifier: String,
        configuration: String
    ) {
        self.modelName = modelName
        self.cloudIdentifier = cloudIdentifier
        self.configuration = configuration
    }
    
    public let modelName: String
    public let cloudIdentifier: String
    public let configuration: String
    
}
