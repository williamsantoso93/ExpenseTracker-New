//
//  ExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct ExpenseScreen: View {
    @State private var isShowAddScreen = false
    var body: some View {
        Form {
            Text("Hello, World!")
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
