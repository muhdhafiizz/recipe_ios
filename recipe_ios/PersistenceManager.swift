//
//  PersistenceManager.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import CoreData
import UIKit

class PersistenceManager {
    static let shared = PersistenceManager()
    
    private init() {}
    
    // Persistent container
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeApp") // Replace "RecipeApp" with your model name
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Managed Object Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save context
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }
}
