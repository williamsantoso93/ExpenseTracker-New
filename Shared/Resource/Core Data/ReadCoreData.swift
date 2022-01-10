//
//  ReadCoreData.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func loadYearMonths(completion: @escaping ([YearMonth]) -> Void) {
        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadIncomes(completion: @escaping ([Income]) -> Void) {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadExpenses(completion: @escaping ([Expense]) -> Void) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadTypes(completion: @escaping ([TypeData]) -> Void) {
        let request: NSFetchRequest<TypeData> = TypeData.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
    
    func loadTempalates(completion: @escaping ([Template]) -> Void) {
        let request: NSFetchRequest<Template> = Template.fetchRequest()
        
        do {
            let data = try viewContext.fetch(request)
            completion(data)
        } catch {
            print(error.localizedDescription)
            completion([])
        }
    }
}
