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
    
    var body: some View {
        Form {
            if !viewModel.expenses.isEmpty {
                ForEach(viewModel.expenses.indices, id:\.self) {index in
                    let expense = viewModel.expenses[index]
                    VStack(alignment: .leading) {
                        Text("id : \(expense.id)")
                        Text("yearMonth : \(expense.yearMonth ?? "")")
                        Text("note : \(expense.note ?? "")")
                        Text("value : \(expense.value ?? 0)")
                        Text("duration : \(expense.duration ?? "")")
                        Text("paymentVia : \(expense.paymentVia ?? "")")
                        Text("type : \(expense.type ?? "")")
                        Text("date : \(expense.date ?? Date())")
                    }
                }
            }
        }
        .refreshable {
            viewModel.loadNewData()
        }
        .navigationTitle("Expense")
        .toolbar {            
            ToolbarItem {
                Button {
                    isShowAddScreen.toggle()
                } label: {
                    Image(systemName: "plus")
                }

            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            
        } content: {
            AddExpenseScreen()
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
