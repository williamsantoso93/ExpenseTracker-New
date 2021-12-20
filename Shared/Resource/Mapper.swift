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
            yearMonthListRemoteToLocal(result.properties)
        }
    }
    
    static func yearMonthListRemoteToLocal(_ remote: YearMonthProperty) -> YearMonth {
        YearMonth(
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
            expenseRemoteToLocal(result.properties)
        }
    }
    
    static func expenseRemoteToLocal(_ remote: ExpenseProperty) -> Expense {
        Expense(
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
            yearMonth: RelationProperty(relation: [Relation(id: local.yearMonth ?? "")]),
            note: RichTextProperty(richText: [RichText(type: "Text", text: TextContent(content: local.note ?? ""))]),
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
            incomeRemoteToLocal(result.properties)
        }
    }
    
    static func incomeRemoteToLocal(_ remote: IncomeProperty) -> Income {
        Income(
            id: remote.id?.title.first?.text.content ?? "",
            yearMonth: remote.yearMonth?.relation.first?.id,
            value: remote.value?.number,
            type: remote.type?.select.name,
            note: remote.note?.richText.first?.text.content
        )
    }
    
    static func mapIncomeLocalToRemote() {
        
    }
    
    static func incomeLocalToRemote() {
        
    }
    
    //MARK: - Type
    static func mapTypeRemoteToLocal() {
        
    }
    
    static func typeRemoteToLocal() {
        
    }
    
    static func mapTypeLocalToRemote() {
        
    }

    static func typeLocalToRemote() {
        
    }
}
