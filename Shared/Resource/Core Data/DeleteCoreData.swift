//
//  DeleteCoreData.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func delete(_ objects: [NSManagedObject]) throws {
        do {
            for object in objects {
                viewContext.delete(object)
            }
            try viewContext.save()
        } catch {
            throw error
        }
    }
    
    func deleteYearMonth(_ data: YearMonthModel) throws {
        let request: NSFetchRequest<YearMonth> = YearMonth.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", data.id)
        
        do {
            let objects = try viewContext.fetch(request)
            try delete(objects)
        } catch {
            throw error
        }
    }
    
    func deleteIncome(_ data: IncomeModel) throws {
        let request: NSFetchRequest<Income> = Income.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", data.id)
        
        do {
            let objects = try viewContext.fetch(request)
            try delete(objects)
        } catch {
            throw error
        }
    }
    
    func deleteExpense(_ data: ExpenseModel) throws {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", data.id)
        
        do {
            let objects = try viewContext.fetch(request)
            try delete(objects)
        } catch {
            throw error
        }
    }
    
    func deleteType(_ data: TypeModel) throws {
        let request: NSFetchRequest<TypeData> = TypeData.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", data.blockID)
        
        do {
            let objects = try viewContext.fetch(request)
            try delete(objects)
        } catch {
            throw error
        }
    }
    
    func deleteTemplate(_ data: TemplateModel) throws {
        let request: NSFetchRequest<Template> = Template.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %@", data.blockID)
        
        do {
            let objects = try viewContext.fetch(request)
            try delete(objects)
        } catch {
            throw error
        }
    }
}
