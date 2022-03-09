//
//  IncomeCDCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct IncomeCDCell: View {
    var income: IncomeCD
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(income.id.uuidString)")
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

struct IncomeCDCell_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCDCell(income: IncomeCD())
    }
}
