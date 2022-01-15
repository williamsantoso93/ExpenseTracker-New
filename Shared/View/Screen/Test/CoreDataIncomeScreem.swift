//
//  CoreDataIncomeScreem.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 09/01/22.
//

import SwiftUI

struct CoreDataIncomeScreem: View {
    var yearMonth: YearMonthModel? = nil
    @State private var isShowAddScreen = false
    @State private var incomes: [IncomeModel] = []
    
    var body: some View {
        Form {
            ForEach(incomes.indices, id:\.self) { index in
                let income = incomes[index]
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
            .onDelete(perform: delete)
        }
        .navigationTitle("Income - CoreData")
        .toolbar {
            ToolbarItem {
                HStack {
                    EditButton()
                    
                    Button {
                        isShowAddScreen = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .sheet(isPresented: $isShowAddScreen) {
            load()
        } content: {
            AddIncomeScreen(income: nil) {
                load()
                isShowAddScreen.toggle()
            }
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let income = self.incomes[index]
            do {
                try CoreDataManager.shared.deleteIncome(income)
                self.incomes.remove(at: index)
                load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.loadIncomes { data in
            self.incomes = Mapper.mapIncomesCoreDataToLocal(data)
        }
    }
}

struct CoreDataIncomeScreem_Previews: PreviewProvider {
    static var previews: some View {
        CoreDataIncomeScreem()
    }
}
