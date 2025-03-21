//
//  CoreDataContainer.swift
//  RunLog
//
//  Created by 신승재 on 3/20/25.
//

import CoreData

final class CoreDataContainer {
    
    lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "DTOs")
      container.loadPersistentStores { storeDescription, error in
        if let error = error as NSError? {
          fatalError("Unresolved error \(error)")
        }
      }
      return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
}

enum CoreDataError: LocalizedError {
    case fetchError
    case deleteError
    case modelNotFound
    case modelAlreadyExist
    case conversionError
    
    var errorDescription: String {
        switch self {
        case .fetchError:
            "Fetch Error"
        case .deleteError:
            "Delete Error"
        case .modelNotFound:
            "Model Not Found"
        case .modelAlreadyExist:
            "Model Already Exist"
        case .conversionError:
            "Conversion Error"
        }
    }
}
