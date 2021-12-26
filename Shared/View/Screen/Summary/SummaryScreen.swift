//
//  SummaryScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct SummaryScreen: View {
    @ObservedObject private var globalData = GlobalData.shared
    @State private var isLoading = false
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
            globalData.getTypes()
            globalData.getYearMonth()
        }
        .loadingView(globalData.isLoading)
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
