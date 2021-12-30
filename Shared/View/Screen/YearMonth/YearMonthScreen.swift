//
//  YearMonthScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct YearMonthScreen: View {
    @State private var isShowAddScreen = false
    @StateObject private var viewModel = YearMonthViewModel()
    
    var body: some View {
        Form {
            if !viewModel.displayYearMonths.isEmpty {
                ForEach(viewModel.displayYearMonths.indices, id:\.self) {index in
                    let displayYearMonth = viewModel.displayYearMonths[index]
                    
                    Section(header: Text(displayYearMonth.year)) {
                        ForEach(displayYearMonth.yearMonths.indices, id:\.self) { index in
                            let yearMonth = displayYearMonth.yearMonths[index]
                            let totalIncomes = yearMonth.totalIncomes ?? 0
                            let totalExpenses = yearMonth.totalExpenses ?? 0
                            
                            VStack(alignment: .leading) {
                                Text(yearMonth.month)
                                Text("Total Income: Rp \(totalIncomes.splitDigit())")
                                Text("Total Expense: Rp \(totalExpenses.splitDigit())")
                            }
                        }
                    }
                }
            }
        }
        .loadingView(GlobalData.shared.isLoading, isNeedDisable: false)
        .refreshable {
            GlobalData.shared.getYearMonth()
        }
        .navigationTitle("YearMonth")
    }}

struct YearMonthScreen_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthScreen()
    }
}
