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
                        IncomeCell(income: income)
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

struct IncomeCDScreen: View {
    @StateObject private var viewModel = IncomeViewModel()
    
    var body: some View {
        Form {
            if !viewModel.incomesCDFilterd.isEmpty {
                ForEach(viewModel.incomesCDFilterd.indices, id:\.self) {index in
                    let income = viewModel.incomesCDFilterd[index]
                    Button {
//                        viewModel.selectIncome(income)
                    } label: {
                        IncomeCDCell(income: income)
                    }
                }
//                .onDelete(perform: viewModel.delete)
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
