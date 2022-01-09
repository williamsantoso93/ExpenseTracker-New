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
    
    private init() {
        presistentContainer = NSPersistentContainer(name: "YearMonth")
        presistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("unable core data \(error)")
            }
        }
    }
}
