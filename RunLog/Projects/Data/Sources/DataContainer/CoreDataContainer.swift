//
//  CoreDataContainer.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import CoreData

public final class CoreDataContainer {
    
    public init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: "DTOs", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load Core Data model named DTOs")
        }
        
        let container = NSPersistentContainer(name: "DTOs", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error: \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}
