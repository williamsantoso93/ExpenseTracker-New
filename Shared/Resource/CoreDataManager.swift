//
//  CoreDataManager.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 09/01/22.
//

import Foundation
import CoreData

class CoreDataManager {
    var presistentContainer: NSPersistentContainer
    
    init() {
        presistentContainer = NSPersistentContainer(name: "YearMonth")
    }
}
