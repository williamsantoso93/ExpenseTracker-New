//
//  ReadCoreData.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func getData<T>(by request: NSFetchRequest<T>) -> [T] {
        do {
            return try context.fetch(request)
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            return []
        }
    }
    
    func getSingleData<T>(by request: NSFetchRequest<T>) -> T? {
        request.fetchLimit = 1
        do {
            return try context.fetch(request).first
        } catch {
            GlobalData.shared.errorMessage = ErrorMessage(title: "Error Core Data", message: error.localizedDescription)
            return nil
        }
    }
    
    func getSingleData<T>(by request: NSFetchRequest<T>, with id: UUID) -> T? {
        request.predicate = NSPredicate(format: "id == %@", id.uuidString)
        
        return getSingleData(by: request)
    }
    
    func getAccountEntity(with id: UUID) -> AccountEntity? {
        let request = NSFetchRequest<AccountEntity>(entityName: EntityName.AccountEntity.rawValue)
        
        return getSingleData(by: request, with: id)
    }
    
    func getAccounts() -> [Account] {
        let request = NSFetchRequest<AccountEntity>(entityName: EntityName.AccountEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(AccountEntity.name), ascending: true)]
        
        return CoreDataMapper.mapAccountEntitiesToLocal(getData(by: request))
    }
    
    func getCategoryEntity(with id: UUID) -> CategoryEntity? {
        let request = NSFetchRequest<CategoryEntity>(entityName: EntityName.CategoryEntity.rawValue)
        
        return getSingleData(by: request, with: id)
    }
    
    func getCategoryEntities() -> [CategoryEntity] {
        let request = NSFetchRequest<CategoryEntity>(entityName: EntityName.CategoryEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CategoryEntity.name), ascending: true)]
        
        return getData(by: request)
    }
    
    func getCategories() -> [Category] {
        let request = NSFetchRequest<CategoryEntity>(entityName: EntityName.CategoryEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CategoryEntity.name), ascending: true)]
        
        return CoreDataMapper.mapCategoryEntitiesToLocal(getData(by: request))
    }
    
    func getCategoryNatureEntity(with id: UUID) -> CategoryNatureEntity? {
        let request = NSFetchRequest<CategoryNatureEntity>(entityName: EntityName.CategoryNatureEntity.rawValue)
        
        return getSingleData(by: request, with: id)
    }
    
    func getCategoryNatures() -> [CategoryNature] {
        let request = NSFetchRequest<CategoryNatureEntity>(entityName: EntityName.CategoryNatureEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(CategoryNatureEntity.name), ascending: true)]
        
        return CoreDataMapper.mapCategoryNatureEntitiesToLocal(getData(by: request))
    }
    
    func getDurations() -> [Duration] {
        let request = NSFetchRequest<DurationEntity>(entityName: EntityName.DurationEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(DurationEntity.name), ascending: true)]
        
        return CoreDataMapper.mapDurationEntitiesToLocal(getData(by: request))
    }
    
    func getPayments() -> [Payment] {
        let request = NSFetchRequest<PaymentEntity>(entityName: EntityName.PaymentEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(PaymentEntity.name), ascending: true)]
        
        return CoreDataMapper.mapPaymentEntitiesToLocal(getData(by: request))
    }
    
    func getStores() -> [Store] {
        let request = NSFetchRequest<StoreEntity>(entityName: EntityName.StoreEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(StoreEntity.name), ascending: true)]
        
        return CoreDataMapper.mapStoreEntitiesToLocal(getData(by: request))
    }
    
    func getSubcategories() -> [Subcategory] {
        let request = NSFetchRequest<SubcategoryEntity>(entityName: EntityName.SubcategoryEntity.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(SubcategoryEntity.name), ascending: true)]
        
        return CoreDataMapper.mapSubcategoryEntitiesToLocal(getData(by: request))
    }
}
