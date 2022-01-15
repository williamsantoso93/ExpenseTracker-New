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
    @State private var isShowErrorMessageAlert = false
    @State var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    
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
                NavigationLink("Template") {
                    templateModelscreen()
                }
                Section {
                    NavigationLink("YearMonth") {
                        CoreDataYearMonth()
                    }
                    NavigationLink("Income") {
                        CoreDataYearMonth(screenType: .income)
                    }
                    NavigationLink("Expense") {
                        CoreDataYearMonth(screenType: .expense)
                    }
                    NavigationLink("Type") {
                        CoreDataTypeScreen()
                    }
                    NavigationLink("Template") {
                        CoreDataTemplateScreen()
                    }
                } header: {
                    Text("Core Data")
                }
            }
            .loadingView(globalData.isLoading, isNeedDisable: false)
            .navigationTitle("Summary")
            .showErrorAlert(isShowErrorMessageAlert: $isShowErrorMessageAlert, errorMessage: errorMessage)
            .onReceive(globalData.$errorMessage) { errorMessage in
                if let errorMessage = errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessageAlert = true
                }
            }
        }
        .refreshable {
            globalData.loadAllRemote()
        }
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
