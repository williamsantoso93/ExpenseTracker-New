//
//  CoreDataExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

struct CoreDataExpenseScreen: View {
    @State private var isShowAddScreen = false
    @State private var expenses: [ExpenseModel] = []
    
    var body: some View {
        Form {
            ForEach(expenses.indices, id:\.self) { index in
                let expense = expenses[index]
                VStack(alignment: .leading) {
                    Text("id : \(expense.id)")
                    Text("yearMonth : \(expense.yearMonth ?? "-")")
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
            .onDelete(perform: delete)
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .navigationTitle("Expense - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            load()
        } content: {
            AddExpenseScreen(expense: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let expense = self.expenses[index]
            do {
                try CoreDataManager.shared.deleteExpense(expense)
                self.expenses.remove(at: index)
                load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.loadExpenses { data in
            self.expenses = Mapper.mapExpensesCoreDataToLocal(data)
        }
    }
}

struct CoreDataExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataExpenseScreen()
    }
}
