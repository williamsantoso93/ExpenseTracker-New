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

struct IncomeCDCell: View {
    var income: IncomeCD
    
    var body: some View {
        VStack(alignment: .leading) {
//                            Text("id : \(income.id)")
//                            Text("yearMonth : \(income.yearMonth ?? "")")
            Text("value : \(income.value.splitDigit())")
            Text("label : \(income.label?.name ?? "-")")
            Text("account : \(income.account?.name ?? "-")")
            Text("category : \(income.category?.name ?? "-")")
            Text("subcategory : \(income.subcategory?.name ?? "-")")
            Text("note : \(income.note ?? "")")
            Text("date : \(income.date .toString())")
        }
    }
}



struct IncomeCell_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCDCell(income: IncomeCD())
    }
}
