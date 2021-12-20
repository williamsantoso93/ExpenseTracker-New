//
//  AddExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct AddExpenseScreen: View {
    var body: some View {
        NavigationView {
            Form {
                Text("Hello, World!")
            }
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AddExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddExpenseScreen()
    }
}
