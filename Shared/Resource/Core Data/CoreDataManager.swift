//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 09/01/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let presistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        presistentContainer.viewContext
    }
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "ExpenseTracker")
        presistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("failed to initialize Core Data \(error)")
            }
        }
    }
}
