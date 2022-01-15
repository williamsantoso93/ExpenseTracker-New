//
//  ExpenseCellView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct ExpenseCellView: View {
    var expense: ExpenseModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(expense.id)")
            Text("notionID : \(expense.notionID ?? "-")")
            Text("yearMonth : \(expense.yearMonth ?? "-")")
            Text("note : \(expense.note ?? "-")")
            Text("store : \(expense.store ?? "-")")
            Text("value : \(expense.value ?? 0)")
            Text("duration : \(expense.duration ?? "-")")
            Text("paymentVia : \(expense.paymentVia ?? "-")")
            if let types = expense.types {
                Text("types : \(types.joinedWithComma())")
            }
            Text("date : \((expense.date ?? Date()).toString())")
        }
    }
}

struct ExpenseCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCellView(expense: Dummy.expense)
    }
}
