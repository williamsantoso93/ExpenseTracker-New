//
//  CoreDataIncomeScreem.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 09/01/22.
//

import SwiftUI

struct CoreDataIncomeScreem: View {
    @State private var isShowAddScreen = false
    @State private var incomes: [IncomeModel] = []
    
    init() {
        self.load()
    }
    var body: some View {
        Form {
            ForEach(incomes.indices, id:\.self) { index in
                let income = incomes[index]
                VStack(alignment: .leading) {
                    Text("id : \(income.id)")
                    //                            Text("yearMonth : \(income.yearMonth ?? "")")
                    Text("value : \(income.value ?? 0)")
                    if let types = income.types {
                        Text("types : \(types.joinedWithComma())")
                    }
                    Text("note : \(income.note ?? "")")
                    Text("date : \((income.date ?? Date()).toString())")
                }
            }
        }
        .navigationTitle("Income - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    Button {
                        load()
                    } label: {
                        Text("Load")
                    }
                    
                    Button {
                        isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
        } content: {
            AddInvoiceScreen(income: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.load { data in
            self.incomes = data.map{ result in
                IncomeModel(
                    blockID: "",
                    id: result.id?.uuidString ?? "",
                    yearMonth: nil,
                    yearMonthID: nil,
                    value: Int(result.value),
                    types: result.types?.split(),
                    note: result.note,
                    date: result.date,
                    keywords: nil
                )
            }
        }
    }
}

struct CoreDataIncomeScreem_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataIncomeScreem()
    }
}