//
//  IncomeCellView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct IncomeCellView: View {
    var income: IncomeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(income.id)")
            Text("notionID : \(income.notionID ?? "-")")
            Text("yearMonth : \(income.yearMonth ?? "")")
            Text("value : \(income.value ?? 0)")
            if let types = income.types {
                Text("types : \(types.joinedWithComma())")
            }
            Text("note : \(income.note ?? "")")
            Text("date : \((income.date ?? Date()).toString())")
        }
    }
}

struct IncomeCellView_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCellView(income: Dummy.income)
    }
}
