//
//  Mapper.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import Foundation

struct Mapper {
    //MARK: - YearMonth
    static func mapYearMonthListRemoteToLocal(_ remote: [ResultProperty<YearMonthProperty>]) -> [YearMonth] {
        remote.map { result in
            yearMonthListRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func yearMonthListRemoteToLocal(_ id: String, _ remote: YearMonthProperty) -> YearMonth {
        YearMonth(
            id: id,
            name: remote.name.title.first?.text.content ?? "",
            month: remote.month.select.name,
            year: remote.year.select.name
        )
    }
    
    static func mapYearMonthLocalToRemote(_ local: [YearMonth]) -> [YearMonthProperty] {
        local.map { result in
            yearMonthLocalToRemote(result)
        }
    }
    
    static func yearMonthLocalToRemote(_ local: YearMonth) -> YearMonthProperty {
        YearMonthProperty(
            name: TitleProperty(title: [Title(text: TextContent(content: local.name))]),
            month: SingleSelectProperty(select: Select(name: local.month)),
            year: SingleSelectProperty(select: Select(name: local.year))
        )
    }
    
    //MARK: - Expense
    static func mapExpenseRemoteToLocal(_ remote: [ResultProperty<ExpenseProperty>]) -> [Expense] {
        remote.map { result in
            expenseRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func expenseRemoteToLocal(_ id: String, _ remote: ExpenseProperty) -> Expense {
        Expense(
            blockID: id,
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: remote.yearMonth?.relation.first?.id,
            note: remote.note?.richText.first?.text.content,
            value: remote.value?.number,
            duration: remote.duration?.select.name,
            paymentVia: remote.paymentVia?.select.name,
            type: remote.type?.select.name,
            date: remote.date?.date.start.toDate()
        )
    }
    
    static func mapExpenseLocalToRemote(_ local: [Expense]) -> [ExpenseProperty] {
        local.map { result in
            expenseLocalToRemote(result)
        }
    }
    
    static func expenseLocalToRemote(_ local: Expense) -> ExpenseProperty {
        ExpenseProperty(
            id: TitleProperty(title: [Title(text: TextContent(content: local.id))]),
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonthID ?? "")]),
            note: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.note ?? ""))]),
            value: NumberProperty(number: local.value ?? 0),
            duration: SingleSelectProperty(select: Select(name: local.duration ?? "")),
            paymentVia: SingleSelectProperty(select: Select(name: local.paymentVia ?? "")),
            type: SingleSelectProperty(select: Select(name: local.type ?? "")),
            date: DateProperty(date: DateModel(start: local.date?.toString() ?? ""))
        )
    }
    
    //MARK: - Income
    static func mapIncomeRemoteToLocal(_ remote: [ResultProperty<IncomeProperty>]) -> [Income] {
        remote.map { result in
            incomeRemoteToLocal(result.id, result.properties)
        }
    }
    
    static func incomeRemoteToLocal(_ id: String, _ remote: IncomeProperty) -> Income {
        Income(
            blockID: id,
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: remote.yearMonth?.relation.first?.id,
            value: remote.value?.number,
            type: remote.type?.select.name,
            note: remote.note?.richText.first?.text.content,
            date: remote.date?.date.start.toDate()
        )
    }
    
    static func mapIncomeLocalToRemote(_ local: [Income]) -> [IncomeProperty] {
        local.map { result in
            incomeLocalToRemote(result)
        }
    }
    
    static func incomeLocalToRemote(_ local: Income) -> IncomeProperty {
        IncomeProperty(
            id: TitleProperty(title: [Title(text: TextContent(content: local.id))]),
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonthID ?? "")]),
            value: NumberProperty(number: local.value ?? 0),
            type: SingleSelectProperty(select: Select(name: local.type ?? "")),
            note: RichTextProperty(richText: [RichText(type: "text", text: TextContent(content: local.note ?? ""))]),
            date: DateProperty(date: DateModel(start: local.date?.toString() ?? ""))
        )
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
            category: remote.category.select.name
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
            category: remote.category?.select.name,
            duration: remote.duration?.select.name,
            paymentVia: remote.paymentVia?.select.name,
            type: remote.type?.select.name,
            value: remote.value?.number
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
            type: textToSingleSelectProperty(local.type),
            value: numberToNumberProperty(local.value)
        )
    }
    
    //MARK: - To Property
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
