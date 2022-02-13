//
//  IncomeScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct IncomeScreen: View {
    @StateObject private var viewModel = IncomeViewModel()
    
    var body: some View {
        Form {
            if !viewModel.incomesFilterd.isEmpty {
                ForEach(viewModel.incomesFilterd.indices, id:\.self) {index in
                    let income = viewModel.incomesFilterd[index]
                    Button {
                        viewModel.selectIncome(income)
                    } label: {
                        VStack(alignment: .leading) {
//                            Text("id : \(income.id)")
//                            Text("yearMonth : \(income.yearMonth ?? "")")
                            Text("value : \((income.value ?? 0).splitDigit())")
                            Text("account : \(income.account ?? "-")")
                            Text("category : \(income.category ?? "-")")
                            Text("subcategory : \(income.subcategory ?? "-")")
                            Text("note : \(income.note ?? "")")
                            Text("date : \((income.date ?? Date()).toString())")
                        }
                    }
                    .onAppear {
                        viewModel.loadMoreList(of: index)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .loadingWithNoDataButton(viewModel.isLoading, isShowNoData: viewModel.isNowShowData, action: {
            viewModel.isShowAddScreen.toggle()
        })
        .searchable(text: $viewModel.searchText)
        .refreshable {
            viewModel.loadNewData()
        }
        .navigationTitle("Income")
        .toolbar {
            ToolbarItem {
                HStack {
#if os(iOS)
                    EditButton()
#endif
                    
                    Button {
                        viewModel.selectIncome()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedIncome = nil
        } content: {
            AddIncomeScreen(income: viewModel.selectedIncome) {
                viewModel.loadNewData()
            }
        }
    }
}

struct IncomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        IncomeScreen()
    }
}
