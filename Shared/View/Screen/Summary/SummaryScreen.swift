//
//  SummaryScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct SummaryScreen: View {
    var body: some View {
        NavigationView{
            Form {
                NavigationLink("YearMonth") {
                    YearMonthScreen()
                }
                NavigationLink("Income") {
                    IncomeScreen()
                }
                NavigationLink("Expense") {
                    ExpenseScreen()
                }
                NavigationLink("Type") {
                    TypeScreen()
                }
            }
            .navigationTitle("Summary")
        }
        .refreshable {
            GlobalData.shared.getTypes()
            GlobalData.shared.getYearMonth()
        }
        .overlay(
            Group {
                if GlobalData.shared.isLoading {
                    ProgressView()
                }
            }
        )
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
