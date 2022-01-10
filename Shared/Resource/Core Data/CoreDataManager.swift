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
                fatalError("unable core data \(error)")
            }
        }
    }
    
    func save(completion: () -> Void) {
        do {
            try viewContext.save()
            completion()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    func load(completion: @escaping ([Income]) -> Void) {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadExpense(completion: @escaping ([Expense]) -> Void) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
}
