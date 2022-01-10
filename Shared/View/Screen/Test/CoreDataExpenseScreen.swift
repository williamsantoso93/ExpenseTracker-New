//
//  CoreDataExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

struct CoreDataExpenseScreen: View {
    @State private var isShowAddScreen = false
    @State private var expense: [ExpenseModel] = []
    init() {
        self.load()
    }
    
    var body: some View {
        Form {
            ForEach(expense.indices, id:\.self) { index in
                let expense = expense[index]
                VStack(alignment: .leading) {
                    Text("id : \(expense.id)")
                    Text("note : \(expense.note ?? "-")")
                    Text("store : \(expense.store ?? "-")")
                    Text("value : \(expense.value ?? 0)")
                    Text("duration : \(expense.duration ?? "-")")
                    Text("paymentVia : \(expense.paymentVia ?? "-")")
                    if let types = expense.types {
                        Text("types : \(types.joinedWithComma())")
                    }
                    Text("date : \((expense.date ?? Date()).toString())")
                }
            }
        }
        .navigationTitle("Expense - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    Button {
                        load()
                    } label: {
                        Text("Load")
                    }
                    
                    Button {
                        isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
        } content: {
            AddExpenseScreen(expense: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    func load() {
        CoreDataManager.shared.loadExpense { data in
            self.expense = data.map{ result in
                ExpenseModel(
                    blockID: "",
                    id: result.id?.uuidString ?? "",
                    yearMonth: nil,
                    yearMonthID: nil,
                    note: result.note,
                    value: Int(result.value),
                    duration: result.duration,
                    paymentVia: result.paymentVia,
                    store: result.store,
                    types: result.types?.split(),
                    date: result.date,
                    keywords: nil
                )
            }
        }
    }
}

struct CoreDataExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataExpenseScreen()
    }
}
