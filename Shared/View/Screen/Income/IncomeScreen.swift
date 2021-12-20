//
//  IncomeScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct IncomeScreen: View {
    @State private var isShowAddScreen = false
    @StateObject private var viewModel = IncomeViewModel()
    
    var body: some View {
        Form {
            if !viewModel.incomes.isEmpty {
                ForEach(viewModel.incomes.indices, id:\.self) {index in
                    let income = viewModel.incomes[index]
                    VStack(alignment: .leading) {
                        Text("id : \(income.id)")
                        Text("yearMonth : \(income.yearMonth ?? "")")
                        Text("value : \(income.value ?? 0)")
                        Text("type : \(income.type ?? "")")
                        Text("note : \(income.note ?? "")")
                    }
                    .onAppear {
                        viewModel.loadMoreList(of: index)
                    }
                }
            }
        }
        .refreshable {
            viewModel.loadNewData()
        }
        .navigationTitle("Income")
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

struct IncomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        IncomeScreen()
    }
}
