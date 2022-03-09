//
//  IncomeCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

struct IncomeCell: View {
    var income: Income
    
    var body: some View {
        VStack(alignment: .leading) {
//                            Text("id : \(income.id)")
//                            Text("yearMonth : \(income.yearMonth ?? "")")
            Text("value : \((income.value ?? 0).splitDigit())")
            Text("label : \(income.label ?? "-")")
            Text("account : \(income.account ?? "-")")
            Text("category : \(income.category ?? "-")")
            Text("subcategory : \(income.subcategory ?? "-")")
            Text("note : \(income.note ?? "")")
            Text("date : \((income.date ?? Date()).toString())")
        }
    }
}

struct IncomeCell_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCell(income: Income(blockID: ""))
    }
}
