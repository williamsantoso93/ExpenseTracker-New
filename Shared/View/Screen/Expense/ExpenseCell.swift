//
//  ExpenseCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

struct ExpenseCell: View {
    var expense: Expense
    var body: some View {
        VStack(alignment: .leading) {
            //                            Text("id : \(expense.id)")
            //                            Text("yearMonth : \(expense.yearMonth ?? "")")
            Text("note : \(expense.note ?? "-")")
            Text("store : \(expense.store ?? "-")")
            Text("value : \((expense.value ?? 0).splitDigit())")
            Text("duration : \(expense.duration ?? "-")")
            Text("payment : \(expense.payment ?? "-")")
            Text("label : \(expense.label ?? "-")")
            Text("account : \(expense.account ?? "-")")
            Text("category : \(expense.category ?? "-")")
            Text("subcategory : \(expense.subcategory ?? "-")")
            Text("date : \((expense.date ?? Date()).toString())")
        }
    }
}

struct ExpenseCell_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCell(expense: Expense(blockID: ""))
    }
}
