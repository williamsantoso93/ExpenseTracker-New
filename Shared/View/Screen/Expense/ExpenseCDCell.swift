//
//  ExpenseCDCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct ExpenseCDCell: View {
    var expense: ExpenseCD
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(expense.id.uuidString)")
            //                            Text("yearMonth : \(expense.yearMonth ?? "")")
            Text("note : \(expense.note ?? "-")")
            Text("store : \(expense.store ?? "-")")
            Text("value : \(expense.value .splitDigit())")
            Group {
                Text("duration : \(expense.duration?.name ?? "-")")
                Text("payment : \(expense.payment?.name ?? "-")")
                Text("label : \(expense.label?.name ?? "-")")
                Text("account : \(expense.account?.name ?? "-")")
                Text("category : \(expense.category?.name ?? "-")")
                Text("subcategory : \(expense.subcategory?.name ?? "-")")
            }
            Group {
                Text("date : \(expense.date.toString())")
                Text("dateCreated : \(expense.dateCreated.toString())")
                Text("dateUpdated : \(expense.dateUpdated.toString())")
            }
            
//            Text("keywords : \(expense.keywords)")
        }
    }
}

struct ExpenseCDCell_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCDCell(expense: ExpenseCD())
    }
}
