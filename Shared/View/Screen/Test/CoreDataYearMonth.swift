//
//  CoreDataYearMonth.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI
import CoreData

struct CoreDataYearMonth: View {
    var screenType: StatementType = .all
    @State private var isShowAddScreen = false
    @State private var yearMonths: [YearMonthModel] = []
    
    var body: some View {
        Form {
            ForEach(yearMonths.indices, id:\.self) { index in
                let yearMonth = yearMonths[index]
                NavigationLink {
                    switch screenType {
                    case .all:
                        AllStatementScreen(yearMonth: yearMonth)
                    case .income:
                        CoreDataIncomeScreem(yearMonth: yearMonth)
                    case .expense:
                        CoreDataExpenseScreen(yearMonth: yearMonth)
                    }
                } label: {
                    YearMonthCellView(yearMonth: yearMonth)
                }
            }
            .onDelete(perform: delete)
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .navigationTitle("YearMonth - \(screenType.rawValue.capitalized)")
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
        .sheet(isPresented: $isShowAddScreen) {
            load()
        } content: {
            switch screenType {
            case .all:
                AddYearMonthScreen(isShowAddScreen: $isShowAddScreen)
            case .income:
                AddIncomeScreen(income: nil) {
                    load()
                    isShowAddScreen.toggle()
                }
            case .expense:
                AddExpenseScreen(expense: nil) {
                    load()
                    isShowAddScreen.toggle()
                }
            }
            
        }
    }
    
    
    func delete(at offsets: IndexSet) {
        offsets.forEach { index in
            let yearMonthModel = self.yearMonths[index]
            do {
                try CoreDataManager.shared.deleteYearMonth(yearMonthModel)
                self.yearMonths.remove(at: index)
                load()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func load() {
        CoreDataManager.shared.loadYearMonths { data in
            self.yearMonths = Mapper.mapYearMonthListCoreDataToLocal(data)
        }
    }
}

struct CoreDataYearMonth_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoreDataYearMonth(screenType: .all)
        }
    }
}

struct AddYearMonthScreen: View {
    @Binding var isShowAddScreen: Bool
    @State private var date = Date()
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }
            .navigationTitle("Add YearMonth")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        isShowAddScreen.toggle()
                    } label: {
                        Text("Cancel")
                    }
                }
#endif
                ToolbarItem {
                    Button {
                        let name = date.toYearMonthString()
                        let month = date.toString(format: "MM MMMM")
                        let year = date.toString(format: "yyyy")
                        
                        let yearMonth = YearMonthModel(
                            id: UUID().uuidString,
                            name: name,
                            month: month,
                            year: year
                        )
                        
                        let yearMonthCD = Mapper.yearMonthLocalToCoreData(yearMonth)
                        CoreDataManager.shared.save { isSuccess in
                            if isSuccess {
                                isShowAddScreen.toggle()
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}
