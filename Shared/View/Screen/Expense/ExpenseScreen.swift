//
//  ExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct ExpenseScreen: View {
    @StateObject private var viewModel = ExpenseViewModel()
    
    var body: some View {
        Form {
            if !viewModel.expenses.isEmpty {
                ForEach(viewModel.expenses.indices, id:\.self) { index in
                    let expense = viewModel.expenses[index]
                    Button {
                        viewModel.selectExpense(expense)
                    } label: {
                        VStack(alignment: .leading) {
//                            Text("id : \(expense.id)")
//                            Text("yearMonth : \(expense.yearMonth ?? "")")
                            Text("note : \(expense.note ?? "")")
                            Text("value : \(expense.value ?? 0)")
                            Text("duration : \(expense.duration ?? "")")
                            Text("paymentVia : \(expense.paymentVia ?? "")")
                            if let types = expense.types {
                                Text("types : \(types.joinedWithComma())")
                            }
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
            viewModel.isShowAddScreen.toggle()
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
                        viewModel.selectExpense()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedExpense = nil
        } content: {
            AddExpenseScreen(expense: viewModel.selectedExpense) {
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
