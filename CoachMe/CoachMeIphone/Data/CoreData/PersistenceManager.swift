//
//  PersistenceManager.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 14.02.2025.
//

import CoreData

class PersistenceManager{
    static let shared = PersistenceManager()
    
    private init() {}
    
    lazy var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores{description, error in
            if let error = error{
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
