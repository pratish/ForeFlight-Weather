//
//  File.swift
//  
//
//  Created by Pratish Karmacharya on 2/23/24.
//

import Foundation
import CoreData


public protocol PersistenceManager {
    var viewContext: NSManagedObjectContext {get}
}

@available(iOS 15.0, *)
public class LocalStorageManager: PersistenceManager {
    public static let shared = LocalStorageManager()
    
    public var viewContext: NSManagedObjectContext { container.viewContext }
    
    public var container: NSPersistentContainer
    
    @available(iOS 15.0, *)
    init() {
        let model = LocalStorageManager.model(for: "Model")
        self.container = .init(name: "Model", managedObjectModel: model)
        self.container.loadPersistentStores(completionHandler: { (desc, err) in
            if let err = err {
                fatalError("Error loading sqlite store: \(desc): \(err)")
            }
            self.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        })
        // Used for developing to verify database
        whereIsMySQLite()
        loadDefaults()
    }
    
    @available(iOS 15.0, *)
    private func loadDefaults() {
        let airports = try? viewContext.fetch(NSFetchRequest(entityName: "AirportEntity"))
        
        guard airports?.isEmpty == true else {
            return
        }
        
        guard let urlPath = Bundle.module.url(forResource: "default", withExtension: "plist") else {
            print("Couldn't find default airports")
            return
        }
        
        if let arrayContents = NSArray(contentsOf: urlPath) {
            for identifier in arrayContents {
                let airport = AirportEntity(context: self.viewContext)
                airport.identifier = identifier as! String
            }
            try? self.viewContext.save()
        } else {
            print("Failed")
        }
        
    }

    func whereIsMySQLite() {
        let path = NSPersistentContainer
            .defaultDirectoryURL()
            .absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .removingPercentEncoding
        
        print(path ?? "Not found")
    }
}

extension PersistenceManager {
    static func model(for name: String) -> NSManagedObjectModel {
        guard let url = Bundle.module.url(forResource: name, withExtension: "momd") else { fatalError("Could not get URL for model: \(name)") }
        guard let model = NSManagedObjectModel(contentsOf: url) else { fatalError("Could not get model for: \(url)") }
        return model
    }
}
