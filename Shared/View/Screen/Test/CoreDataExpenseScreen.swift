//
//  CoreDataExpenseScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI

class CoreDataExpenseViewModel: ObservableObject {
    var yearMonth: YearMonthModel?
    
    @Published var isShowAddScreen = false
    var selectedExpense: ExpenseModel? = nil
    @Published var expenses: [ExpenseModel] = []
    @Published var isLoading = false
    
    init(yearMonth: YearMonthModel?) {
        self.yearMonth = yearMonth
    }
    
    func loadData() {
        getList { expenses in
            self.expenses = expenses
        }
    }
    
    func getList(completion: @escaping ([ExpenseModel]) -> Void) {
        CoreDataManager.shared.loadExpenses(by: yearMonth) { data in
            completion(Mapper.mapExpensesCoreDataToLocal(data))
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let expense = self.expenses[index]
            do {
                try CoreDataManager.shared.deleteExpense(expense)
                self.expenses.remove(at: index)
                loadData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func selectExpense(_ expenseModel: ExpenseModel? = nil) {
        selectedExpense = expenseModel
        isShowAddScreen = true
    }
}

struct CoreDataExpenseScreen: View {
    var yearMonth: YearMonthModel? = nil
    @StateObject var viewModel: CoreDataExpenseViewModel
    
    init(yearMonth: YearMonthModel? = nil) {
        _viewModel = StateObject(wrappedValue: CoreDataExpenseViewModel(yearMonth: yearMonth))
    }
    
    var body: some View {
        Form {
            ForEach(viewModel.expenses.indices, id:\.self) { index in
                let expense = viewModel.expenses[index]
                Button {
                    viewModel.selectExpense(expense)
                } label: {
                    VStack(alignment: .leading) {
                        Text("id : \(expense.id)")
                        Text("yearMonth : \(expense.yearMonth ?? "-")")
                        Text("note : \(expense.note ?? "-")")
                        Text("store : \(expense.store ?? "-")")
                        Text("value : \(expense.value ?? 0)")
                        Text("duration : \(expense.duration ?? "-")")
                        Text("paymentVia : \(expense.paymentVia ?? "-")")
                        if let types = expense.types {
                            Text("types : \(types.joinedWithComma())")
                        }
                        Text("date : \((expense.date ?? Date()).toString())")
                    }
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .onAppear(perform: viewModel.loadData)
        .refreshable {
            viewModel.loadData()
        }
        .navigationTitle("Expense - CoreData")
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
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedExpense = nil
        } content: {
            AddExpenseScreen(expense: viewModel.selectedExpense) {
                viewModel.loadData()
                viewModel.isShowAddScreen.toggle()
            }
        }
    }
}

struct CoreDataExpenseScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataExpenseScreen()
    }
}
