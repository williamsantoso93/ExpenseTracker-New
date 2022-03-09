//
//  CoreDataManager.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 22/02/22.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "ExpenseTracker")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error  {
                GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            }
        }
        context = container.viewContext
    }
    
    enum EntityName: String {
        case LabelEntity
        case AccountEntity
        case CategoryEntity
        case CategoryNatureEntity
        case DurationEntity
        case ExpenseEntity
        case IncomeEntity
        case PaymentEntity
        case StoreEntity
        case SubcategoryEntity
        case TemplateEntity
        case YearMonthEntity
    }
    
    //MARK: - Entity
//    var accountsEntity: [AccountEntity] = []
//    var categoryEntity: [CategoryEntity] = []
//    var categoryNatureEntity: [CategoryNatureEntity] = []
//    var durationEntity: [DurationEntity] = []
//    var expenseEntity: [ExpenseEntity] = []
//    var incomeEntity: [IncomeEntity] = []
//    var oaymentEntity: [PaymentEntity] = []
//    var storeEntity: [StoreEntity] = []
//    var subcategoryEntity: [SubcategoryEntity] = []
//    var templateEntity: [TemplateEntity] = []
//    var yearMonthEntity: [YearMonthEntity] = []
    
    func save(completion: (_ isSuccess: Bool) -> Void = { isSuccess in }) {
        do {
            try context.save()
            completion(true)
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            context.rollback()
            completion(false)
        }
    }
    
    func saveThrows() throws {
        do {
            try context.save()
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            context.rollback()
            throw error
        }
    }
    
    func save() {
        do {
            try context.save()
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            context.rollback()
        }
    }
}

extension CoreDataManager {
    func addAccount() {
        let newAccount = AccountEntity(context: context)
        newAccount.id = UUID()
        newAccount.name = "test"
        newAccount.expenses = []
        save()
    }
    
    func updateAccount() {
        save()
    }
    
//    func deleteAccount(_ account: AccountEntity) {
//        context.delete(account)
//        save()
//    }
    
    func addExpense(account: AccountEntity) {
        let newExpense = ExpenseEntity(context: context)
        newExpense.id = UUID()
        newExpense.value = 0
        newExpense.note = ""
        newExpense.date = Date()
        newExpense.dateCreated = Date()
        newExpense.dateUpdated = Date()
//        newExpense.addToAccount account
        save()
    }
    
    func getExpenses() -> [ExpenseEntity] {
        let request = NSFetchRequest<ExpenseEntity>(entityName: EntityName.ExpenseEntity.rawValue)
        
        do {
            return try context.fetch(request)
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            return []
        }
    }
}
