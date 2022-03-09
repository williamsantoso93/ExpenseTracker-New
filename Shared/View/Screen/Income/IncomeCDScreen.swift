//
//  IncomeCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct IncomeCDScreen: View {
    @StateObject private var viewModel = IncomeCDViewModel()
    
    var body: some View {
        Form {
            if !viewModel.incomesFilterd.isEmpty {
                ForEach(viewModel.incomesFilterd.indices, id:\.self) {index in
                    let income = viewModel.incomesFilterd[index]
                    Button {
                        viewModel.selectIncome(income)
                    } label: {
                        IncomeCDCell(income: income)
                    }
                }
                .onDelete(perform: viewModel.delete)
            }
        }
        .searchable(text: $viewModel.searchText)
        .refreshable {
            viewModel.loadData()
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
            AddIncomeCDScreen(incomeCD: viewModel.selectedIncome) {
                viewModel.loadData()
            }
        }
    }
}

struct IncomeCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        IncomeCDScreen()
    }
}
