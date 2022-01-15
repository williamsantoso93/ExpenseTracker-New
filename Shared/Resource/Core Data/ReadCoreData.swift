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
    
    func getYearMonths(by date: Date?) -> YearMonth? {
        let date = date ?? Date()
        let name = date.toYearMonthString()

        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            if let yearMonth = try viewContext.fetch(request).first {
                return yearMonth
            } else {
                return createYearMonth(using: date)
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func getYearMonths(by id: String) -> YearMonth? {
        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            if let yearMonth = try viewContext.fetch(request).first {
                return yearMonth
            } else {
                return nil
            }
        } catch {
            print(error)
            return nil
        }
    }
    
    func loadYearMonths(completion: @escaping ([YearMonth]) -> Void) {
        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadIncomes(by yearMonth: YearMonthModel? = nil, completion: @escaping ([Income]) -> Void) {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        
        if let yearMonthID = yearMonth?.id {
            if let yearMonth = getYearMonths(by: yearMonthID) {
                request.predicate = NSPredicate(format: "yearMonth == %@", yearMonth.objectID)
            }
        }
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Income.date), ascending: false)]
        
        load(request: request) { data in
            completion(data)
        }
    }
    
    func loadExpenses(by yearMonth: YearMonthModel? = nil, completion: @escaping ([Expense]) -> Void) {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        if let yearMonthID = yearMonth?.id {
            if let yearMonth = getYearMonths(by: yearMonthID) {
                request.predicate = NSPredicate(format: "yearMonth == %@", yearMonth.objectID)
            }
        }
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Expense.date), ascending: false)]
        
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
