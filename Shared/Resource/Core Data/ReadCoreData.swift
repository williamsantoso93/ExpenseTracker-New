//
//  ReadCoreData.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func load<T>(request: NSFetchRequest<T>, completion: @escaping ([T]) -> Void) {
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadYearMonths(completion: @escaping ([YearMonth]) -> Void) {
        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadIncomes(completion: @escaping ([Income]) -> Void) {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadExpenses(completion: @escaping ([Expense]) -> Void) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadTypes(completion: @escaping ([TypeData]) -> Void) {
        let request: NSFetchRequest<TypeData> = TypeData.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadTempalates(completion: @escaping ([Template]) -> Void) {
        let request: NSFetchRequest<Template> = Template.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
}
