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
            if !viewModel.incomes.isEmpty {
                ForEach(viewModel.incomes.indices, id:\.self) {index in
                    let income = viewModel.incomes[index]
                    Button {
                        viewModel.selectIncome(income)
                    } label: {
                        VStack(alignment: .leading) {
//                            Text("id : \(income.id)")
//                            Text("yearMonth : \(income.yearMonth ?? "")")
                            Text("value : \(income.value ?? 0)")
                            Text("types : \(income.type ?? "")")
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
            AddInvoiceScreen(income: viewModel.selectedIncome) {
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
