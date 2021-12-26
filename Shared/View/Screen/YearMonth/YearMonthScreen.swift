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
                        ForEach(displayYearMonth.months.indices, id:\.self) { index in
                            let month = displayYearMonth.months[index]
                            
                            VStack(alignment: .leading) {
                                Text(month)
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
