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
                Button("get") {
                    getData()
                }
                Button("post") {
                    post()
                }
            }
            .navigationTitle("Summary")
        }
        .onAppear {
            getData()
        }
    }
    
    func getData() {
        Networking.shared.getYearMonth()
    }
    
    func post() {
        Networking.shared.postYearMonth()
    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
