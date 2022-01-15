//
//  AllStatementScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct AllStatementScreen: View {
    var yearMonth: YearMonthModel
    var title: String {
        yearMonth.name
    }
    
    var body: some View {
        Form {
            Section {
                ForEach(0 ..< 1) { item in
                    IncomeCellView(income: Dummy.income)
                }
            } header: {
                Text("Income")
            }
            
            Section {
                ForEach(0 ..< 1) { item in
                    ExpenseCellView(expense: Dummy.expense)
                }
            } header: {
                Text("Expense")
            }
        }
        .navigationTitle(title)
    }
}

struct AllStatementScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AllStatementScreen(yearMonth: Dummy.yearMonth)
        }
    }
}
