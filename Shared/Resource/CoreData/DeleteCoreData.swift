//
//  DeleteCoreData.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func deleteData(_ entities: [NSManagedObject]) {
        for entity in entities {
            context.delete(entity)
        }
        save()
    }
    
    func deleteSingleData(_ entity: NSManagedObject) {
        context.delete(entity)
        save()
    }
    
    func deleteSingleData<T>(by request: NSFetchRequest<T>, with id: UUID) {
        guard let entity = getSingleData(by: request, with: id) as? NSManagedObject else { return }
        
        deleteSingleData(entity)
    }
    
    func deleteAccount(_ account: Account) {
        let request = NSFetchRequest<AccountEntity>(entityName: EntityName.AccountEntity.rawValue)
        
        deleteSingleData(by: request, with: account.id)
    }
    
    func deleteCategory(_ category: Category) {
        let request = NSFetchRequest<CategoryEntity>(entityName: EntityName.CategoryEntity.rawValue)
        
        deleteSingleData(by: request, with: category.id)
    }
    
    func deleteCategoryNature(_ categoryNature: CategoryNature) {
        let request = NSFetchRequest<CategoryNatureEntity>(entityName: EntityName.CategoryNatureEntity.rawValue)
        deleteSingleData(by: request, with: categoryNature.id)
    }
    
    func deleteDuration(_ duration: Duration) {
        let request = NSFetchRequest<DurationEntity>(entityName: EntityName.DurationEntity.rawValue)
        
        deleteSingleData(by: request, with: duration.id)
    }
    
    func deletePayment(_ payment: Payment) {
        let request = NSFetchRequest<PaymentEntity>(entityName: EntityName.PaymentEntity.rawValue)
        
        deleteSingleData(by: request, with: payment.id)
    }
    
    func deleteStore(_ store: Store) {
        let request = NSFetchRequest<StoreEntity>(entityName: EntityName.StoreEntity.rawValue)
        
        deleteSingleData(by: request, with: store.id)
    }
    
    func deleteSubcategory(_ subcategory: Subcategory) {
        let request = NSFetchRequest<SubcategoryEntity>(entityName: EntityName.SubcategoryEntity.rawValue)
        
        deleteSingleData(by: request, with: subcategory.id)
    }
    
    func deleteExpense(_ expense: ExpenseCD) {
        let request = NSFetchRequest<SubcategoryEntity>(entityName: EntityName.ExpenseEntity.rawValue)
        
        deleteSingleData(by: request, with: expense.id)
    }
    
    func deleteIncome(_ income: IncomeCD) {
        let request = NSFetchRequest<SubcategoryEntity>(entityName: EntityName.IncomeEntity.rawValue)
        
        deleteSingleData(by: request, with: income.id)
    }
    
    func deleteTemplateModel(_ templateModel: TemplateModelCD) {
        let request = NSFetchRequest<SubcategoryEntity>(entityName: EntityName.TemplateEntity.rawValue)
        
        deleteSingleData(by: request, with: templateModel.id)
    }
}
