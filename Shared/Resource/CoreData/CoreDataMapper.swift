//
//  CoreDataMapper.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import Foundation
import CoreData

struct CoreDataMapper {
    static let manager = CoreDataManager.shared
    static let context = CoreDataManager.shared.context
    
    //MARK: - LabelModel
    static func mapLabelEntitiesToLocal(_ entities: [LabelEntity]) -> [LabelModel] {
        entities.map { entity in
            labelEntityToLocal(entity)
        }
    }
    
    static func labelEntityToLocal(_ entity: LabelEntity?) -> LabelModel? {
        guard let entity = entity else {
            return nil
        }

        return labelEntityToLocal(entity)
    }
    
    static func labelEntityToLocal(_ entity: LabelEntity) -> LabelModel {
        LabelModel(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        
        return entity
    }
    
    //MARK: - Account
    static func mapAccountEntitiesToLocal(_ entities: [AccountEntity]) -> [Account] {
        entities.map { entity in
            accountEntityToLocal(entity)
        }
    }
    
    static func accountEntityToLocal(_ entity: AccountEntity?) -> Account? {
        guard let entity = entity else {
            return nil
        }
        
        return accountEntityToLocal(entity)
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        
        return entity
    }
    
    //MARK: - Category
    static func mapCategoryEntitiesToLocal(_ entities: [CategoryEntity]) -> [Category] {
        entities.map { entity in
            categoryEntityToLocal(entity)
        }
    }
    
    static func categoryEntityToLocal(_ entity: CategoryEntity?) -> Category? {
        guard let entity = entity else {
            return nil
        }
        
        return categoryEntityToLocal(entity)
    }
    
    static func categoryEntityToLocal(_ entity: CategoryEntity) -> Category {
        let subcategories = entity.subcategoryOf?.allObjects as? [SubcategoryEntity] ?? []
        
        var category = categoryEntityToLocalNoSubcategory(entity)
        category.nature = categoryNatureEntityToLocalNoCategory(entity.nature)
        category.subcategoryOf = mapSubcategoryEntitiesToLocal(subcategories)
        
        return category
    }
    
    static func categoryEntityToLocalNoSubcategory(_ entity: CategoryEntity?) -> Category? {
        guard let entity = entity else {
            return nil
        }
        
        return categoryEntityToLocalNoSubcategory(entity)
    }
    
    static func categoryEntityToLocalNoSubcategory(_ entity: CategoryEntity) -> Category {
        Category(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            type: entity.type ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        if let nature = local.nature {
            if let natureEntity = manager.getCategoryNatureEntity(with: nature.id) {
                entity.nature = natureEntity
            }
        }
        
        return entity
    }
        
    //MARK: - CategoryNature
    static func mapCategoryNatureEntitiesToLocal(_ entities: [CategoryNatureEntity]) -> [CategoryNature] {
        entities.map { entity in
            categoryNatureEntityToLocal(entity)
        }
    }
    
    static func categoryNatureEntityToLocal(_ entity: CategoryNatureEntity?) -> CategoryNature? {
        guard let entity = entity else {
            return nil
        }
        
        return categoryNatureEntityToLocal(entity)
    }
    
    static func categoryNatureEntityToLocal(_ entity: CategoryNatureEntity) -> CategoryNature {
        let categories = entity.categories?.allObjects as? [CategoryEntity] ?? []
        
        var nature = categoryNatureEntityToLocalNoCategory(entity)
        nature.categories = mapCategoryEntitiesToLocal(categories)
        
        return nature
    }
    
    static func categoryNatureEntityToLocalNoCategory(_ entity: CategoryNatureEntity?) -> CategoryNature? {
        guard let entity = entity else {
            return nil
        }
        
        return categoryNatureEntityToLocalNoCategory(entity)
    }
    
    static func categoryNatureEntityToLocalNoCategory(_ entity: CategoryNatureEntity) -> CategoryNature {
        CategoryNature(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        entity.categories?.addingObjects(from: mapLocalToCategoryEntities(local.categories))
        
        return entity
    }
    
    //MARK: - Duration
    static func mapDurationEntitiesToLocal(_ entities: [DurationEntity]) -> [Duration] {
        entities.map { entity in
            durationEntityToLocal(entity)
        }
    }
    
    static func durationEntityToLocal(_ entity: DurationEntity?) -> Duration? {
        guard let entity = entity else {
            return nil
        }
        
        return durationEntityToLocal(entity)
    }
    
    static func durationEntityToLocal(_ entity: DurationEntity) -> Duration {
        Duration(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        
        return entity
    }
    
    //MARK: - Payment
    static func mapPaymentEntitiesToLocal(_ entities: [PaymentEntity]) -> [Payment] {
        entities.map { entity in
            paymentEntityToLocal(entity)
        }
    }
    
    static func paymentEntityToLocal(_ entity: PaymentEntity?) -> Payment? {
        guard let entity = entity else {
            return nil
        }
        
        return paymentEntityToLocal(entity)
    }
    
    static func paymentEntityToLocal(_ entity: PaymentEntity) -> Payment {
        Payment(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        
        return entity
    }
    
    //MARK: - Store
    static func mapStoreEntitiesToLocal(_ entities: [StoreEntity]) -> [Store] {
        entities.map { entity in
            storeEntityToLocal(entity)
        }
    }
    
    static func storeEntityToLocal(_ entity: StoreEntity?) -> Store? {
        guard let entity = entity else {
            return nil
        }
        
        return storeEntityToLocal(entity)
    }
    
    static func storeEntityToLocal(_ entity: StoreEntity) -> Store {
        Store(
            id: entity.id ?? UUID(),
            isHaveMultipleStore: entity.isHaveMultipleStore,
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        
        return entity
    }
    
    //MARK: - Subcategory
    static func mapSubcategoryEntitiesToLocal(_ entities: [SubcategoryEntity]) -> [Subcategory] {
        entities.map { entity in
            subcategoryEntityToLocal(entity)
        }
    }
    
    static func subcategoryEntityToLocal(_ entity: SubcategoryEntity?) -> Subcategory? {
        guard let entity = entity else {
            return nil
        }
        
        return subcategoryEntityToLocal(entity)
    }
    
    static func subcategoryEntityToLocal(_ entity: SubcategoryEntity) -> Subcategory {
        Subcategory(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date(),
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
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        if let mainCategory = local.mainCategory {
            if let mainCategoryEntity = manager.getCategoryEntity(with: mainCategory.id) {
                entity.mainCategory = mainCategoryEntity
            }
        }
        
        return entity
    }
    
    //MARK: - Expense
    static func mapExpenseEntitiesToLocal(_ entities: [ExpenseEntity]) -> [ExpenseCD] {
        entities.map { entity in
            expenseEntityToLocal(entity)
        }
    }
    
    static func expenseEntityToLocal(_ entity: ExpenseEntity) -> ExpenseCD {
        ExpenseCD(
            id: entity.id ?? UUID(),
            note: entity.note,
            value: entity.value,
            label: labelEntityToLocal(entity.label),
            account: accountEntityToLocal(entity.account),
            category: categoryEntityToLocal(entity.category),
            subcategory: subcategoryEntityToLocal(entity.subcategory),
            duration: durationEntityToLocal(entity.duration),
            payment: paymentEntityToLocal(entity.payment),
            store: entity.store,
            date: entity.date ?? Date(),
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
        )
    }
    
    static func mapLocalToExpenseEntities(_ local: [ExpenseCD]) -> [ExpenseEntity] {
        local.map { local in
            localToExpenseEntity(local)
        }
    }
    
    static func localToExpenseEntity(_ local: ExpenseCD) -> ExpenseEntity {
        let entity = ExpenseEntity(context: context)
        
        entity.id = local.id
        entity.date = local.date
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        entity.value = local.value
        entity.note = local.note
        entity.store = local.store
        
        if let id = local.label?.id {
            entity.label = manager.getLabelEntity(with: id)
        }
        if let id = local.account?.id {
            entity.account = manager.getAccountEntity(with: id)
        }
        if let id = local.category?.id {
            entity.category = manager.getCategoryEntity(with: id)
        }
        if let id = local.subcategory?.id {
            entity.subcategory = manager.getSubcategoryEntity(with: id)
        }
        if let id = local.duration?.id {
            entity.duration = manager.getDurationEntity(with: id)
        }
        if let id = local.payment?.id {
            entity.payment = manager.getPaymentEntity(with: id)
        }
        
        //        entity.yearMonth
        
        return entity
    }
    
    //MARK: - Income
    static func mapIncomeEntitiesToLocal(_ entities: [IncomeEntity]) -> [IncomeCD] {
        entities.map { entity in
            incomeEntityToLocal(entity)
        }
    }
    
    static func incomeEntityToLocal(_ entity: IncomeEntity) -> IncomeCD {
        IncomeCD(
            id: entity.id ?? UUID(),
            note: entity.note,
            value: entity.value,
            label: labelEntityToLocal(entity.label),
            account: accountEntityToLocal(entity.account),
            category: categoryEntityToLocal(entity.category),
            subcategory: subcategoryEntityToLocal(entity.subcategory),
            date: entity.date ?? Date(),
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date()
        )
    }
    
    static func mapLocalToIncomeEntities(_ local: [IncomeCD]) -> [IncomeEntity] {
        local.map { local in
            localToIncomeEntity(local)
        }
    }
    
    static func localToIncomeEntity(_ local: IncomeCD) -> IncomeEntity {
        let entity = IncomeEntity(context: context)
        
        entity.id = local.id
        entity.date = local.date
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        entity.value = local.value
        entity.note = local.note
        
        if let id = local.label?.id {
            entity.label = manager.getLabelEntity(with: id)
        }
        if let id = local.account?.id {
            entity.account = manager.getAccountEntity(with: id)
        }
        if let id = local.category?.id {
            entity.category = manager.getCategoryEntity(with: id)
        }
        if let id = local.subcategory?.id {
            entity.subcategory = manager.getSubcategoryEntity(with: id)
        }
        
        //        entity.yearMonth
        
        return entity
    }
    
    //MARK: - TemplateModel
    static func mapTemplateModelEntitiesToLocal(_ entities: [TemplateEntity]) -> [TemplateModelCD] {
        entities.map { entity in
            templateModelEntityToLocal(entity)
        }
    }
    
    static func templateModelEntityToLocal(_ entity: TemplateEntity) -> TemplateModelCD {
        TemplateModelCD(
            id: entity.id ?? UUID(),
            name: entity.name,
            value: entity.value,
            label: labelEntityToLocal(entity.label),
            account: accountEntityToLocal(entity.account),
            category: categoryEntityToLocal(entity.category),
            subcategory: subcategoryEntityToLocal(entity.subcategory),
            duration: durationEntityToLocal(entity.duration),
            payment: paymentEntityToLocal(entity.payment),
            store: entity.store,
            date: entity.date ?? Date(),
            dateCreated: entity.dateCreated ?? Date(),
            dateUpdated: entity.dateUpdated ?? Date(),
            type: entity.type ?? "expense"
        )
    }
    
    static func mapLocalToTemplateModelEntities(_ local: [TemplateModelCD]) -> [TemplateEntity] {
        local.map { local in
            localToTemplateModelEntity(local)
        }
    }
    
    static func localToTemplateModelEntity(_ local: TemplateModelCD) -> TemplateEntity {
        let entity = TemplateEntity(context: context)
        
        entity.id = local.id
        entity.date = local.date
        entity.dateCreated = local.dateCreated
        entity.dateUpdated = local.dateUpdated
        entity.value = local.value
        entity.name = local.name
        entity.store = local.store
        entity.type = local.type
        
        if let id = local.label?.id {
            entity.label = manager.getLabelEntity(with: id)
        }
        if let id = local.account?.id {
            entity.account = manager.getAccountEntity(with: id)
        }
        if let id = local.category?.id {
            entity.category = manager.getCategoryEntity(with: id)
        }
        if let id = local.subcategory?.id {
            entity.subcategory = manager.getSubcategoryEntity(with: id)
        }
        if let id = local.duration?.id {
            entity.duration = manager.getDurationEntity(with: id)
        }
        if let id = local.payment?.id {
            entity.payment = manager.getPaymentEntity(with: id)
        }
        
        return entity
    }
}
