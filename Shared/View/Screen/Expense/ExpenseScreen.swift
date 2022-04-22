//
//  ExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct ExpenseScreen: View {
    @StateObject private var viewModel: ExpenseViewModel
    
    init(expenses: [Expense] = []) {
        _viewModel = StateObject(wrappedValue: ExpenseViewModel(expenses: expenses))
    }
    
    var body: some View {
        Form {
            if !viewModel.expensesFilterd.isEmpty {
                ForEach(viewModel.expensesFilterd.indices, id:\.self) { index in
                    let expense = viewModel.expensesFilterd[index]
                    Button {
                        viewModel.selectExpense(expense)
                    } label: {
                        VStack(alignment: .leading) {
//                            Text("id : \(expense.id)")
//                            Text("yearMonth : \(expense.yearMonth ?? "")")
                            Text("note : \(expense.note ?? "-")")
                            Text("store : \(expense.store ?? "-")")
                            Text("value : \((expense.value ?? 0).splitDigit())")
                            Text("duration : \(expense.duration ?? "-")")
                            Text("payment : \(expense.payment ?? "-")")
                            Text("label : \(expense.label ?? "-")")
                            Text("account : \(expense.account ?? "-")")
                            Group {
                                Text("category : \(expense.category ?? "-")")
                                Text("subcategory : \(expense.subcategory ?? "-")")
                                Text("date : \((expense.date ?? Date()).toString())")
                                Text("isDoneExport : \(expense.isDoneExport ? "true" : "false")")
                            }
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
        .searchable(text: $viewModel.searchText)
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
