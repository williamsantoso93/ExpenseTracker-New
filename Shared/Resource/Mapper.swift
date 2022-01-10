//
//  Mapper.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation
import CoreData

struct Mapper {
    static let viewContext = CoreDataManager.shared.viewContext
    
    //MARK: - YearMonthModel
    static func mapYearMonthListRemoteToLocal(_ remote: [ResultProperty<YearMonthProperty>]) -> [YearMonthModel] {
        remote.map { result in
            yearMonthListRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func yearMonthListRemoteToLocal(_ id: String, _ remote: YearMonthProperty) -> YearMonthModel {
        YearMonthModel(
            id: id,
            name: remote.name.title.first?.text.content ?? "",
            month: remote.month.select?.name ?? "",
            year: remote.year.select?.name ?? "",
            totalIncomes: remote.totalIncomes?.rollup.number ?? 0,
            totalExpenses: remote.totalExpenses?.rollup.number ?? 0
        )
    }
    
    static func mapYearMonthLocalToRemote(_ local: [YearMonthModel]) -> [YearMonthProperty] {
        local.map { result in
            yearMonthLocalToRemote(result)
        }
    }
    
    static func yearMonthLocalToRemote(_ local: YearMonthModel) -> YearMonthProperty {
        YearMonthProperty(
            name: TitleProperty(title: [Title(text: TextContent(content: local.name))]),
            month: SingleSelectProperty(select: Select(name: local.month)),
            year: SingleSelectProperty(select: Select(name: local.year)),
            totalIncomes: nil,
            totalExpenses: nil
        )
    }
    
    static func mapYearMonthListCoreDataToLocal(_ coreData: [YearMonth]) -> [YearMonthModel] {
        coreData.map { result in
            yearMonthListCoreDataToLocal(result)
        }
    }
    
    static func yearMonthListCoreDataToLocal(_ coreData: YearMonth) -> YearMonthModel {
        YearMonthModel(
            id: coreData.id?.uuidString ?? "",
            name: coreData.name ?? "",
            month: coreData.month ?? "",
            year: coreData.year ?? "",
            totalIncomes: 0,
            totalExpenses: 0
        )
    }
    
    static func mapYearMonthLocalToCoreData(_ local: [YearMonthModel]) -> [YearMonth] {
        local.map { result in
            yearMonthLocalToCoreData(result)
        }
    }
    
    static func yearMonthLocalToCoreData(_ local: YearMonthModel) -> YearMonth {
        let yearMonth = YearMonth(context: viewContext)
        
        yearMonth.id = UUID(uuidString: local.id)
        yearMonth.name = local.name
        yearMonth.year = local.year
        yearMonth.month = local.month
        
        return yearMonth
    }
    
    //MARK: - Expense
    static func mapExpenseRemoteToLocal(_ remote: [ResultProperty<ExpenseProperty>]) -> [ExpenseModel] {
        remote.map { result in
            expenseRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func expenseRemoteToLocal(_ id: String, _ remote: ExpenseProperty) -> ExpenseModel {
        ExpenseModel(
            blockID: id,
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: remote.yearMonth?.relation.first?.id,
            note: remote.note?.richText.first?.text.content,
            value: remote.value?.number,
            duration: remote.duration?.select?.name ?? "",
            paymentVia: remote.paymentVia?.select?.name ?? "",
            store: remote.store?.richText.first?.text.content,
            types: multiSelectsToStrings(remote.types?.multiSelect),
            date: remote.date?.date.start.toDate(),
            keywords: remote.keywords?.formula.string
        )
    }
    
    static func mapExpenseLocalToRemote(_ local: [ExpenseModel]) -> [ExpenseProperty] {
        local.map { result in
            expenseLocalToRemote(result)
        }
    }
    
    static func expenseLocalToRemote(_ local: ExpenseModel) -> ExpenseProperty {
        ExpenseProperty(
            id: TitleProperty(title: [Title(text: TextContent(content: local.id))]),
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonthID ?? "")]),
            note: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.note ?? ""))]),
            value: NumberProperty(number: local.value ?? 0),
            duration: SingleSelectProperty(select: Select(name: local.duration ?? "")),
            paymentVia: SingleSelectProperty(select: Select(name: local.paymentVia ?? "")),
            store: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.store ?? ""))]),
            types: MultiSelectProperty(multiSelect: stringsToMultiSelects(local.types)),
            date: DateProperty(date: DateModel(start: local.date?.toString() ?? ""))
        )
    }
    
    static func mapEpxensesCoreDataToLocal(_ coreData: [Expense]) -> [ExpenseModel] {
        coreData.map { result in
            epxenseCoreDataToLocal(result)
        }
    }
    
    static func epxenseCoreDataToLocal(_ coreData: Expense) -> ExpenseModel {
        ExpenseModel(
            blockID: coreData.id?.uuidString ?? "",
            id: coreData.id?.uuidString ?? "",
            yearMonth: "",
            note: coreData.note,
            value: Int(coreData.value),
            duration: coreData.duration,
            paymentVia: coreData.paymentVia,
            store: coreData.store,
            types: coreData.types?.split(),
            date: coreData.date,
            keywords: ""
        )
    }
    
    static func mapEpxensesLocalToCoreData(_ local: [ExpenseModel]) -> [Expense] {
        local.map { result in
            epxenseLocalToCoreData(result)
        }
    }
    
    static func epxenseLocalToCoreData(_ local: ExpenseModel) -> Expense {
        let expense = Expense(context: viewContext)
        
        expense.id = UUID(uuidString: local.id)
        expense.note = local.note
        expense.types = local.types?.joinedWithCommaNoSpace()
        expense.value = Int64(local.value ?? 0)
        expense.duration = local.duration
        expense.paymentVia = local.paymentVia
        expense.store = local.store
        expense.date = local.date
        
        return expense
    }
    
    //MARK: - Income
    static func mapIncomeRemoteToLocal(_ remote: [ResultProperty<IncomeProperty>]) -> [IncomeModel] {
        remote.map { result in
            incomeRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func incomeRemoteToLocal(_ id: String, _ remote: IncomeProperty) -> IncomeModel {
        IncomeModel(
            blockID: id,
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: remote.yearMonth?.relation.first?.id,
            value: remote.value?.number,
            types: multiSelectsToStrings(remote.types?.multiSelect),
            note: remote.note?.richText.first?.text.content,
            date: remote.date?.date.start.toDate(),
            keywords: remote.keywords?.formula.string
        )
    }
    
    static func mapIncomeLocalToRemote(_ local: [IncomeModel]) -> [IncomeProperty] {
        local.map { result in
            incomeLocalToRemote(result)
        }
    }
    
    static func incomeLocalToRemote(_ local: IncomeModel) -> IncomeProperty {
        IncomeProperty(
            id: TitleProperty(title: [Title(text: TextContent(content: local.id))]),
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonthID ?? "")]),
            value: NumberProperty(number: local.value ?? 0),
            types: MultiSelectProperty(multiSelect: stringsToMultiSelects(local.types)),
            note: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.note ?? ""))]),
            date: DateProperty(date: DateModel(start: local.date?.toString() ?? ""))
        )
    }
    
    static func mapIncomesCoreDataToLocal(_ coreData: [Income]) -> [IncomeModel] {
        coreData.map { result in
            incomeCoreDataToLocal(result)
        }
    }
    
    static func incomeCoreDataToLocal(_ coreData: Income) -> IncomeModel {
        IncomeModel(
            blockID: coreData.id?.uuidString ?? "",
            id: coreData.id?.uuidString ?? "",
            yearMonth: "",
            value: Int(coreData.value),
            types: coreData.types?.split(),
            note: coreData.note,
            date: coreData.date,
            keywords: ""
        )
    }
    
    static func mapIncomesLocalToCoreData(_ local: [IncomeModel]) -> [Income] {
        local.map { result in
            incomeLocalToCoreData(result)
        }
    }
    
    static func incomeLocalToCoreData(_ local: IncomeModel) -> Income {
        let income = Income(context: viewContext)
        
        income.id = UUID(uuidString: local.id)
        income.note = local.note
        income.types = local.types?.joinedWithCommaNoSpace()
        income.value = Int64(local.value ?? 0)
        income.date = local.date
        
        return income
    }
    
    //MARK: - Type
    static func mapTypeRemoteToLocal(_ remote: [ResultProperty<TypeProperty>]) -> [TypeModel] {
        remote.map { result in
            typeRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func typeRemoteToLocal(_ id: String, _ remote: TypeProperty) -> TypeModel {
        TypeModel(
            blockID: id,
            name: remote.name.title.first?.text.content ?? "",
            category: remote.category.select?.name ?? "",
            keywords: remote.keywords?.formula.string
        )
    }
    
    static func mapTypeLocalToRemote(_ local: [TypeModel]) -> [TypeProperty] {
        local.map { result in
            typeLocalToRemote(result)
        }
    }
    
    static func typeLocalToRemote(_ local: TypeModel) -> TypeProperty {
        TypeProperty(
            name: TitleProperty(title: [Title(text: TextContent(content: local.name))]),
            category: SingleSelectProperty(select: Select(name: local.category))
        )
    }
    
    static func mapTypesCoreDataToLocal(_ coreData: [TypeData]) -> [TypeModel] {
        coreData.map { result in
            typeCoreDataToLocal(result)
        }
    }
    
    static func typeCoreDataToLocal(_ coreData: TypeData) -> TypeModel {
        TypeModel(
            blockID: coreData.id?.uuidString ?? "",
            name: coreData.name ?? "",
            category: coreData.category ?? "",
            keywords: ""
        )
    }
    
    
    static func mapTypesLocalToCoreData(_ local: [TypeModel]) -> [TypeData] {
        local.map { result in
            typeLocalToCoreData(result)
        }
    }
    
    static func typeLocalToCoreData(_ local: TypeModel) -> TypeData {
        let type = TypeData(context: viewContext)
        
        type.id = UUID(uuidString: local.blockID)
        type.name = local.name
        type.category = local.category
        
        return type
    }
    
    //MARK: - Setting
    static func mapTemplateModelRemoteToLocal(_ remote: [ResultProperty<TemplateModelProperty>]) -> [TemplateModel] {
        remote.map { result in
            templateModelRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func templateModelRemoteToLocal(_ id: String, _ remote: TemplateModelProperty) -> TemplateModel {
        TemplateModel(
            blockID: id,
            name: remote.name?.title.first?.text.content,
            category: remote.category?.select?.name ?? "",
            duration: remote.duration?.select?.name ?? "",
            paymentVia: remote.paymentVia?.select?.name ?? "",
            store: remote.store?.richText.first?.text.content,
            types: multiSelectsToStrings(remote.types?.multiSelect),
            value: remote.value?.number,
            keywords: remote.keywords?.formula.string
        )
    }
    
    static func mapTemplateModelLocalToRemote(_ local: [TemplateModel]) -> [TemplateModelProperty] {
        local.map { result in
            templateModelLocalToRemote(result)
        }
    }
    
    static func templateModelLocalToRemote(_ local: TemplateModel) -> TemplateModelProperty {
        TemplateModelProperty(
            name: TitleProperty(title: [Title(text: TextContent(content: local.name ?? ""))]),
            category: textToSingleSelectProperty(local.category),
            duration: textToSingleSelectProperty(local.duration),
            paymentVia: textToSingleSelectProperty(local.paymentVia),
            types: MultiSelectProperty(multiSelect: stringsToMultiSelects(local.types)),
            value: numberToNumberProperty(local.value),
            store: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.store ?? ""))])
        )
    }
    
    static func mapTemplateCoreDataToLocal(_ coreData: [Template]) -> [TemplateModel] {
        coreData.map { result in
            templateCoreDataToLocal(result)
        }
    }
    
    static func templateCoreDataToLocal(_ coreData: Template) -> TemplateModel {
        TemplateModel(
            blockID: coreData.id?.uuidString ?? "",
            name: coreData.name,
            category: coreData.category,
            duration: coreData.duration,
            paymentVia: coreData.paymentVia,
            store: coreData.store,
            types: coreData.types?.split(),
            value: Int(coreData.value),
            keywords: ""
        )
    }
    
    static func mapTemplatesLocalToCoreData(_ local: [TemplateModel]) -> [Template] {
        local.map { result in
            templateLocalToCoreData(result)
        }
    }
    
    static func templateLocalToCoreData(_ local: TemplateModel) -> Template {
        let template = Template(context: viewContext)
        
        template.id = UUID(uuidString: local.blockID)
        template.name = local.name
        template.category = local.category
        template.types = local.types?.joinedWithCommaNoSpace()
        template.value = Int64(local.value ?? 0)
        template.duration = local.duration
        template.paymentVia = local.paymentVia
        template.store = local.store
        
        return template
    }
    
    //MARK: - Error Message
    static func errorMessageRemoteToLocal(_ remote: ErrorResponse) -> ErrorMessage {
        ErrorMessage(
            title: remote.code,
            message: remote.message
        )
    }
    
    //MARK: - To Property
    static func multiSelectsToStrings(_ multiSelects: [Select]?) -> [String]? {
        guard let multiSelects = multiSelects else { return nil }
        guard !multiSelects.isEmpty else { return nil }
        
        return multiSelects.map { result in
            result.name
        }
    }
    
    static func stringsToMultiSelects(_ strings: [String]?) -> [Select]? {
        guard let strings = strings else { return nil }
        guard !strings.isEmpty else { return nil }
        
        let map = strings.map { result in
            Select(name: result)
        }
        
        return map
    }
    
    static func textToSingleSelectProperty(_ text: String?) -> SingleSelectProperty? {
        guard let text = text else {
            return nil
        }
        guard !text.isEmpty else {
            return nil
        }
        
        return SingleSelectProperty(select: Select(name: text))
    }
    
    static func numberToNumberProperty(_ value: Int?) -> NumberProperty? {
        guard let value = value else {
            return nil
        }
        guard value != 0 else {
            return nil
        }
        
        return NumberProperty(number: value)
    }
}
