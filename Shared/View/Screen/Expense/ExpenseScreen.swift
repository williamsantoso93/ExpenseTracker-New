//
//  ExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct ExpenseScreen: View {
    @State private var isShowAddScreen = false
    @StateObject private var viewModel = ExpenseViewModel()
    
    @State private var selectedExpense: Expense?
    
    var body: some View {
        Form {
            if !viewModel.expenses.isEmpty {
                ForEach(viewModel.expenses.indices, id:\.self) { index in
                    let expense = viewModel.expenses[index]
                    Button {
                        selectedExpense = viewModel.expenses[index]
                        isShowAddScreen.toggle()
                    } label: {
                        VStack(alignment: .leading) {
//                            Text("id : \(expense.id)")
//                            Text("yearMonth : \(expense.yearMonth ?? "")")
                            Text("note : \(expense.note ?? "")")
                            Text("value : \(expense.value ?? 0)")
                            Text("duration : \(expense.duration ?? "")")
                            Text("paymentVia : \(expense.paymentVia ?? "")")
                            Text("type : \(expense.type ?? "")")
                            Text("date : \((expense.date ?? Date()).toString())")
                        }
                    }
                    .onAppear {
                        viewModel.loadMoreList(of: index)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .loadingWithNoDataButton(viewModel.isLoading, isShowNoData: viewModel.isNowShowData, action: {
            isShowAddScreen.toggle()
        })
        .refreshable {
            viewModel.loadNewData()
        }
        .navigationTitle("Expense")
        .toolbar {            
            ToolbarItem {
                HStack {
#if os(iOS)
                    EditButton()
#endif
                    Button {
                        isShowAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            selectedExpense = nil
        } content: {
            AddExpenseScreen(expense: selectedExpense) {
                viewModel.loadNewData()
            }
        }

    }
}

struct ExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExpenseScreen()
        }
    }
}
