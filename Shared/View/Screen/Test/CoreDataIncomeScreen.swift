//
//  CoreDataIncomeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 09/01/22.
//

import SwiftUI

class CoreDataIncomeViewModel: ObservableObject {
    var yearMonth: YearMonthModel?
    
    @Published var isShowAddScreen = false
    var selectedIncome: IncomeModel? = nil
    @Published var incomes: [IncomeModel] = []
    @Published var isLoading = false
    
    init(yearMonth: YearMonthModel?) {
        self.yearMonth = yearMonth
    }
    
    func loadData() {
        getList { incomes in
            self.incomes = incomes
        }
    }
    
    func getList(completion: @escaping ([IncomeModel]) -> Void) {
        CoreDataManager.shared.loadIncomes(by: yearMonth) { data in
            completion(Mapper.mapIncomesCoreDataToLocal(data))
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let income = self.incomes[index]
            do {
                try CoreDataManager.shared.deleteIncome(income)
                self.incomes.remove(at: index)
                loadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func selectIncome(_ income: IncomeModel? = nil) {
        selectedIncome = income
        isShowAddScreen = true
    }
}

struct CoreDataIncomeScreen: View {
    var yearMonth: YearMonthModel? = nil
    
    @StateObject var viewModel: CoreDataIncomeViewModel
    
    init(yearMonth: YearMonthModel? = nil) {
        _viewModel = StateObject(wrappedValue: CoreDataIncomeViewModel(yearMonth: yearMonth))
    }
    
    var body: some View {
        Form {
            ForEach(viewModel.incomes.indices, id:\.self) { index in
                let income = viewModel.incomes[index]
                Button {
                    viewModel.selectIncome(income)
                } label: {
                    VStack(alignment: .leading) {
                        Text("id : \(income.id)")
                        Text("yearMonth : \(income.yearMonth ?? "")")
                        Text("value : \(income.value ?? 0)")
                        if let types = income.types {
                            Text("types : \(types.joinedWithComma())")
                        }
                        Text("note : \(income.note ?? "")")
                        Text("date : \((income.date ?? Date()).toString())")
                    }
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .navigationTitle("Income - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        viewModel.isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear(perform: viewModel.loadData)
        .refreshable {
            viewModel.loadData()
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedIncome = nil
        } content: {
            AddIncomeScreen(income: viewModel.selectedIncome) {
                viewModel.loadData()
                viewModel.isShowAddScreen.toggle()
            }
        }
    }
}

struct CoreDataIncomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataIncomeScreen()
    }
}
