//
//  CoreDataYearMonth.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI
import CoreData

struct CoreDataYearMonth: View {
    @State private var isShowAddScreen = false
    @State private var yearMonths: [YearMonthModel] = []
    
    var body: some View {
        Form {
            ForEach(yearMonths.indices, id:\.self) { index in
                let yearMonth = yearMonths[index]
                VStack(alignment: .leading) {
                    Text("id : \(yearMonth.id)")
                    Text("name : \(yearMonth.name)")
                    Text("year : \(yearMonth.year)")
                    Text("month : \(yearMonth.month)")
                }
            }
            .onDelete(perform: delete)
        }
        .onAppear(perform: load)
        .refreshable {
            load()
        }
        .navigationTitle("YearMonth - CoreData")
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
            AddYearMonthScreen(isShowAddScreen: $isShowAddScreen)
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
        CoreDataYearMonth()
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
