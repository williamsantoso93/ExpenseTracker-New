//
//  DummyScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 22/02/22.
//

import SwiftUI
//impo

class DummyViewModel: ObservableObject {
    let manager = CoreDataManager.shared
    @Published var accounts: [AccountEntity] = []
    @Published var expenses: [ExpenseEntity] = []

    init() {
        getData()
    }
    
    func getData() {
//        accounts = manager.getAccounts()
//        expenses = manager.getExpenses()
    }
    
    func addData() {
//        manager.addAccount()
        getData()
    }
    
    
    func updateData() {
        guard accounts.count > 1 else { return }
        let updatedAccount = accounts[0]
        updatedAccount.name = "Account 1"
        manager.save()
        getData()
    }
    
    func deleteData() {
        for i in accounts.indices {
            if i > 0 {
//                manager.deleteAccount(accounts[i])
            }
        }
        getData()
    }
    
    func addExpense() {
        guard accounts.count > 1 else { return }
//        manager.addExpense(account: accounts[0])
        getData()
    }
}

struct DummyScreen: View {
    @StateObject var viewModel = DummyViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Button {
                    viewModel.addData()
                } label: {
                    Text("add account")
                }
                Button {
                    viewModel.updateData()
                } label: {
                    Text("update account")
                }
                Button {
                    viewModel.deleteData()
                } label: {
                    Text("delete account")
                }
                Section("Accounts") {
                    ForEach(viewModel.accounts.indices, id:\.self) { index in
                        let account = viewModel.accounts[index]
                        VStack(alignment: .leading) {
                            Text("id: \(account.id?.uuidString ?? "")")
                            Text("name: \(account.name ?? "")")
                            
                            if let expenses = account.expenses?.allObjects as? [ExpenseEntity] {
                                VStack(alignment: .leading) {
                                    Text("\nExpenses: ")
                                    ForEach(expenses.indices, id:\.self) { index in
                                        let expense = expenses[index]
                                        ExpenseView(expense: expense)
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        }
                    }
                }
                
                Button {
                    viewModel.addExpense()
                } label: {
                    Text("add expense")
                }
                Section("Expenses") {
                    ForEach(viewModel.expenses.indices, id:\.self) { index in
                        let expense = viewModel.expenses[index]
                        ExpenseView(expense: expense)
                    }
                }
            }
            .navigationTitle("core data")
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button {
                            viewModel.getData()
                        } label: {
                            Text("get")
                        }
                        Button {
                            viewModel.addData()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}

struct DummyScreen_Previews: PreviewProvider {
    static var previews: some View {
        DummyScreen()
    }
}

struct ExpenseView: View {
    var expense: ExpenseEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Text("id: \(expense.id?.uuidString ?? "")")
            Text("name: \(expense.value)")
            Text("note: \(expense.note ?? "")")
            Text("date: \(expense.date?.toString() ?? "")")
            
            VStack(alignment: .leading) {
                Text("Account: ")
                Text("id: \(expense.account?.id?.uuidString ?? "")")
                Text("name: \(expense.account?.name ?? "")")
            }
            .padding(.top, 4)
            .padding(.leading, 8)
        }
    }
}
