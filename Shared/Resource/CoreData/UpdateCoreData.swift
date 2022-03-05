//
//  UpdateCoreData.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func updateLabel(_ local: LabelModel) {
        let entity = getLabelEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updateAccount(_ local: Account) {
        let entity = getAccountEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updateCategory(_ local: Category) {
        let entity = getCategoryEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.type = local.type
            entity.dateUpdated = Date()
            if let nature = local.nature {
                if let natureEntity = getCategoryNatureEntity(with: nature.id) {
                    entity.nature = natureEntity
                }
            }
            
            save()
        }
    }
    
    func updateCategoryNature(_ local: CategoryNature) {
        let entity = getCategoryNatureEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updateDuration(_ local: Duration) {
        let entity = getDurationEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updatePayment(_ local: Payment) {
        let entity = getPaymentEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updateStore(_ local: Store) {
        let entity = getStoreEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.isHaveMultipleStore = local.isHaveMultipleStore
            entity.dateUpdated = Date()
            
            save()
        }
    }
    
    func updateSubcategory(_ local: Subcategory) {
        let entity = getSubcategoryEntity(with: local.id)
        
        if let entity = entity {
            entity.name = local.name
            entity.dateUpdated = Date()
            if let mainCategory = local.mainCategory {
                if let mainCategoryEntity = getCategoryEntity(with: mainCategory.id) {
                    entity.mainCategory = mainCategoryEntity
                }
            }
            
            save()
        }
    }
    
    func updateExpense(_ local: ExpenseCD) {
        let entity = getExpenseEntity(with: local.id)
        
        if let entity = entity {
            entity.date = local.date
            entity.dateUpdated = Date()
            entity.value = local.value
            entity.note = local.note
            entity.store = local.store
            
            if let id = local.label?.id {
                entity.label = getLabelEntity(with: id)
            }
            if let id = local.account?.id {
                entity.account = getAccountEntity(with: id)
            }
            if let id = local.category?.id {
                entity.category = getCategoryEntity(with: id)
            }
            if let id = local.subcategory?.id {
                entity.subcategory = getSubcategoryEntity(with: id)
            }
            if let id = local.duration?.id {
                entity.duration = getDurationEntity(with: id)
            }
            if let id = local.payment?.id {
                entity.payment = getPaymentEntity(with: id)
            }
            
            save()
        }
    }
    
    func updateIncome(_ local: IncomeCD) {
        let entity = getIncomeEntity(with: local.id)
        
        if let entity = entity {
            entity.date = local.date
            entity.dateUpdated = Date()
            entity.value = local.value
            entity.note = local.note
            
            if let id = local.label?.id {
                entity.label = getLabelEntity(with: id)
            }
            if let id = local.account?.id {
                entity.account = getAccountEntity(with: id)
            }
            if let id = local.category?.id {
                entity.category = getCategoryEntity(with: id)
            }
            if let id = local.subcategory?.id {
                entity.subcategory = getSubcategoryEntity(with: id)
            }
            
            save()
        }
    }
    
    func updateTemplateModel(_ local: TemplateModelCD) {
        let entity = getTemplateModelEntity(with: local.id)
        
        if let entity = entity {
            entity.date = local.date
            entity.dateUpdated = Date()
            entity.value = local.value
            entity.name = local.name
            entity.store = local.store
            
            if let id = local.label?.id {
                entity.label = getLabelEntity(with: id)
            }
            if let id = local.account?.id {
                entity.account = getAccountEntity(with: id)
            }
            if let id = local.category?.id {
                entity.category = getCategoryEntity(with: id)
            }
            if let id = local.subcategory?.id {
                entity.subcategory = getSubcategoryEntity(with: id)
            }
            if let id = local.duration?.id {
                entity.duration = getDurationEntity(with: id)
            }
            if let id = local.payment?.id {
                entity.payment = getPaymentEntity(with: id)
            }
            
            save()
        }
    }
}
