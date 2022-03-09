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
    @StateObject var viewModel = SummaryViewModel()
    
    var body: some View {
        NavigationView{
            Form {
                Section {
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
                        TemplateModelscreen()
                    }
                    NavigationLink("Others") {
                        OthersScreen()
                    }
                }
                
                Section {
                    Button("Add Income") {
                        viewModel.isAddIncomeShow.toggle()
                    }
                    Button("Add Expense") {
                        viewModel.isAddExpenseShow.toggle()
                    }
                }
                .disabled(globalData.isLoading)
                
                Section {
                    NavigationLink("IncomeCD") {
                        IncomeCDScreen()
                    }
                    NavigationLink("ExpenseCD") {
                        ExpenseCDScreen()
                    }
                    Button("Add IncomeCD") {
                        viewModel.isAddIncomeCDShow.toggle()
                    }
                    Button("Add ExpenseCD") {
                        viewModel.isAddExpenseCDShow.toggle()
                    }
                }
            }
            .loadingView(globalData.isLoading, isNeedDisable: false)
            .navigationTitle("Summary")
            .networkErrorAlert()
            .overlay() {
                VStack {
                    Spacer()
                     
                    Color.clear
                        .contentShape(Rectangle())
                        .onLongPressGesture(minimumDuration: 2) {
                            viewModel.isSelectUser = true
                        }
                        .frame(height: 44)
                }
            }
        }
        .refreshable {
            globalData.loadAll()
        }
#if os(iOS)
        .fullScreenCover(isPresented: $viewModel.isSelectUser) {
            
        } content: {
            SelectUsercreen()
        }
#else
        .sheet(isPresented: $viewModel.isSelectUser) {
            
        } content: {
            SelectUsercreen()
        }
#endif
        .sheet(isPresented: $viewModel.isAddIncomeShow) {
        } content: {
            AddIncomeScreen() {
            }
        }
        .sheet(isPresented: $viewModel.isAddExpenseShow) {
        } content: {
            AddExpenseScreen() {
            }
        }
        .sheet(isPresented: $viewModel.isAddIncomeCDShow) {
        } content: {
            AddIncomeCDScreen() {
            }
        }
        .sheet(isPresented: $viewModel.isAddExpenseCDShow) {
        } content: {
            AddExpenseCDScreen() {
            }
        }
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
