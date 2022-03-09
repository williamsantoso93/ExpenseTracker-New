//
//  ExpenseCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct ExpenseCDScreen: View {
    @StateObject private var viewModel = ExpenseCDViewModel()
    
    var body: some View {
        Form {
            if !viewModel.expensesFilterd.isEmpty {
                ForEach(viewModel.expensesFilterd.indices, id:\.self) { index in
                    let expense = viewModel.expensesFilterd[index]
                    Button {
                        viewModel.selectExpense(expense)
                    } label: {
                        ExpenseCDCell(expense: expense)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .searchable(text: $viewModel.searchText)
        .refreshable {
            viewModel.loadData()
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
            AddExpenseCDScreen(expenseCD: viewModel.selectedExpense) {
                viewModel.loadData()
            }
        }
    }
}

struct ExpenseCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseCDScreen()
    }
}
