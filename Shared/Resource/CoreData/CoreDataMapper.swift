//
//  CoreDataMapper.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

//TODO: move to model
struct LabelModel: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
}

struct Account: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
}

struct Category: Codable {
    var id: UUID = UUID()
    let name: String
    let type: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
    var categoryNature: CategoryNature? = nil
    var subcategoryOf: [Subcategory] = []
}

struct CategoryNature: Codable {
    var id: UUID = UUID()
    let name: String
    var categories: [Category] = []
}

struct Duration: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
}

struct Payment: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
}

struct Store: Codable {
    var id: UUID = UUID()
    let isHaveMultipleStore: Bool
    let name: String
}

struct Subcategory: Codable {
    var id: UUID = UUID()
    let name: String
    var expenses: [Expense] = []
    var incomes: [Income] = []
    var mainCategory: Category? = nil
}

// ---
struct CoreDataMapper {
    static let manager = CoreDataManager.shared
    static let context = CoreDataManager.shared.context
    
    //MARK: - LabelModel
    static func mapLabelEntitiesToLocal(_ entities: [LabelEntity]) -> [LabelModel] {
        entities.map { entity in
            labelEntityToLocal(entity)
        }
    }
    
    static func labelEntityToLocal(_ entity: LabelEntity) -> LabelModel {
        LabelModel(
            id: entity.id ?? UUID(),
            name: entity.name ?? ""
        )
    }
    
    static func mapLocalToLabelEntities(_ local: [LabelModel]) -> [LabelEntity] {
        local.map { local in
            localToLabelEntity(local)
        }
    }
    
    static func localToLabelEntity(_ local: LabelModel) -> LabelEntity {
        let entity = LabelEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        
        return entity
    }
    
    //MARK: - Account
    static func mapAccountEntitiesToLocal(_ entities: [AccountEntity]) -> [Account] {
        entities.map { entity in
            accountEntityToLocal(entity)
        }
    }
    
    static func accountEntityToLocal(_ entity: AccountEntity) -> Account {
        Account(
            id: entity.id ?? UUID(),
            name: entity.name ?? ""
        )
    }
    
    static func mapLocalToAccountEntities(_ local: [Account]) -> [AccountEntity] {
        local.map { local in
            localToAccountEntity(local)
        }
    }
    
    static func localToAccountEntity(_ local: Account) -> AccountEntity {
        let entity = AccountEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        
        return entity
    }
    
    //MARK: - Category
    static func mapCategoryEntitiesToLocal(_ entities: [CategoryEntity]) -> [Category] {
        entities.map { entity in
            categoryEntityToLocal(entity)
        }
    }
    
    static func categoryEntityToLocal(_ entity: CategoryEntity) -> Category {
        let subcategories = entity.subcategoryOf?.allObjects as? [SubcategoryEntity] ?? []
        
        return Category(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            type: entity.type ?? "",
            subcategoryOf: mapSubcategoryEntitiesToLocal(subcategories)
        )
    }
    
    static func categoryEntityToLocalNoSubcategory(_ entity: CategoryEntity?) -> Category? {
        guard let entity = entity else {
            return nil
        }

        return Category(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            type: entity.type ?? ""
        )
    }
    
    static func mapLocalToCategoryEntities(_ local: [Category]) -> [CategoryEntity] {
        local.map { local in
            localToCategoryEntity(local)
        }
    }
    
    static func localToCategoryEntity(_ local: Category) -> CategoryEntity {
        let entity = CategoryEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        entity.type = local.type
        
        return entity
    }
        
    //MARK: - CategoryNature
    static func mapCategoryNatureEntitiesToLocal(_ entities: [CategoryNatureEntity]) -> [CategoryNature] {
        entities.map { entity in
            categoryNatureEntityToLocal(entity)
        }
    }
    
    static func categoryNatureEntityToLocal(_ entity: CategoryNatureEntity) -> CategoryNature {
        let categories = entity.categories?.allObjects as? [CategoryEntity] ?? []
        
        return CategoryNature(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            categories: mapCategoryEntitiesToLocal(categories)
        )
    }
    
    static func mapLocalToCategoryNatureEntities(_ local: [CategoryNature]) -> [CategoryNatureEntity] {
        local.map { local in
            localToCategoryNatureEntity(local)
        }
    }
    
    static func localToCategoryNatureEntity(_ local: CategoryNature) -> CategoryNatureEntity {
        let entity = CategoryNatureEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        entity.categories?.addingObjects(from: mapLocalToCategoryEntities(local.categories))
        
        return entity
    }
    
    //MARK: - Duration
    static func mapDurationEntitiesToLocal(_ entities: [DurationEntity]) -> [Duration] {
        entities.map { entity in
            durationEntityToLocal(entity)
        }
    }
    
    static func durationEntityToLocal(_ entity: DurationEntity) -> Duration {
        Duration(
            id: entity.id ?? UUID(),
            name: entity.name ?? ""
        )
    }
    
    static func mapLocalToDurationEntities(_ local: [Duration]) -> [DurationEntity] {
        local.map { local in
            localToDurationEntity(local)
        }
    }
    
    static func localToDurationEntity(_ local: Duration) -> DurationEntity {
        let entity = DurationEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        
        return entity
    }
    
    //MARK: - Payment
    static func mapPaymentEntitiesToLocal(_ entities: [PaymentEntity]) -> [Payment] {
        entities.map { entity in
            paymentEntityToLocal(entity)
        }
    }
    
    static func paymentEntityToLocal(_ entity: PaymentEntity) -> Payment {
        Payment(
            id: entity.id ?? UUID(),
            name: entity.name ?? ""
        )
    }
    
    static func mapLocalToPaymentEntities(_ local: [Payment]) -> [PaymentEntity] {
        local.map { local in
            localToPaymentEntity(local)
        }
    }
    
    static func localToPaymentEntity(_ local: Payment) -> PaymentEntity {
        let entity = PaymentEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        
        return entity
    }
    
    //MARK: - Store
    static func mapStoreEntitiesToLocal(_ entities: [StoreEntity]) -> [Store] {
        entities.map { entity in
            storeEntityToLocal(entity)
        }
    }
    
    static func storeEntityToLocal(_ entity: StoreEntity) -> Store {
        Store(
            id: entity.id ?? UUID(),
            isHaveMultipleStore: entity.isHaveMultipleStore,
            name: entity.name ?? ""
        )
    }
    
    static func mapLocalToStoreEntities(_ local: [Store]) -> [StoreEntity] {
        local.map { local in
            localToStoreEntity(local)
        }
    }
    
    static func localToStoreEntity(_ local: Store) -> StoreEntity {
        let entity = StoreEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        entity.isHaveMultipleStore = local.isHaveMultipleStore
        
        return entity
    }
    
    //MARK: - Subcategory
    static func mapSubcategoryEntitiesToLocal(_ entities: [SubcategoryEntity]) -> [Subcategory] {
        entities.map { entity in
            subcategoryEntityToLocal(entity)
        }
    }
    
    static func subcategoryEntityToLocal(_ entity: SubcategoryEntity) -> Subcategory {
        Subcategory(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            mainCategory: categoryEntityToLocalNoSubcategory(entity.mainCategory)
        )
    }
    
    static func mapLocalToSubcategoryEntities(_ local: [Subcategory]) -> [SubcategoryEntity] {
        local.map { local in
            localToSubcategoryEntity(local)
        }
    }
    
    static func localToSubcategoryEntity(_ local: Subcategory) -> SubcategoryEntity {
        let entity = SubcategoryEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        if let mainCategory = local.mainCategory {
            if let mainCategoryEntity = manager.getCategoryEntity(with: mainCategory.id) {
                entity.mainCategory = mainCategoryEntity
            }
        }
        
        return entity
    }
    
    
    static func localToSubcategoryEntity(_ local: Subcategory, mainCategoryEntity: CategoryEntity) -> SubcategoryEntity {
        let entity = SubcategoryEntity(context: context)
        
        entity.id = local.id
        entity.name = local.name
        
        entity.mainCategory = mainCategoryEntity
        return entity
    }
}
