//
//  YearMonthScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct YearMonthScreen: View {
    @State private var isShowAddScreen = false
    @StateObject private var viewModel = YearMonthViewModel()
    
    var body: some View {
        Form {
            if !viewModel.yearMonths.isEmpty {
                ForEach(viewModel.yearMonths.indices, id:\.self) {index in
                    let yearMonth = viewModel.yearMonths[index]
                    VStack(alignment: .leading) {
                        Text("name : \(yearMonth.name)")
                        Text("year : \(yearMonth.year)")
                        Text("month : \(yearMonth.month)")
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
        .navigationTitle("YearMonth")
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
    }}

struct YearMonthScreen_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthScreen()
    }
}
