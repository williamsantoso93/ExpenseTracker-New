//
//  SummaryScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct SummaryScreen: View {
    var body: some View {
        NavigationView{
            Form {
                NavigationLink("Income") {
                    Text("Hello")
                }
                NavigationLink("Expense") {
                    ExpenseScreen()
                }
            }
            .navigationTitle("Summary")
        }
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
