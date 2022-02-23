//
//  CreateCoreData.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func createAccount(_ account: Account) {
        _ = CoreDataMapper.localToAccountEntity(account)
        save()
    }
    
    func createCategory(_ category: Category) {
        _ = CoreDataMapper.localToCategoryEntity(category)
        save()
    }
    
    func createCategoryNature(_ categoryNature: CategoryNature) {
        _ = CoreDataMapper.localToCategoryNatureEntity(categoryNature)
        save()
    }
    
    func createDuration(_ duration: Duration) {
        _ = CoreDataMapper.localToDurationEntity(duration)
        save()
    }
    
    func createPayment(_ payment: Payment) {
        _ = CoreDataMapper.localToPaymentEntity(payment)
        save()
    }
    
    func createStore(_ store: Store) {
        _ = CoreDataMapper.localToStoreEntity(store)
        save()
    }
    
    func createSubcategory(_ subcategory: Subcategory) {
        _ = CoreDataMapper.localToSubcategoryEntity(subcategory)
        save()
    }
    
    func createSubcategory(_ subcategory: Subcategory, mainCategoryEntity: CategoryEntity) {
        _ = CoreDataMapper.localToSubcategoryEntity(subcategory, mainCategoryEntity: mainCategoryEntity)
        save()
    }
}
