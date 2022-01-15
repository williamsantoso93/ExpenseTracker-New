//
//  CoreDataYearMonth.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import SwiftUI
import CoreData

class CoreDataYearMonthViewModel: ObservableObject {
    var screenType: StatementType
    
    @Published var isShowAddScreen = false
    @Published var yearMonths: [YearMonthModel] = []
    
    init(screenType: StatementType) {
        self.screenType = screenType
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

struct CoreDataYearMonth: View {
    @StateObject var viewModel: CoreDataYearMonthViewModel
    
    init(screenType: StatementType = .all) {
        _viewModel = StateObject(wrappedValue: CoreDataYearMonthViewModel(screenType: screenType))
    }
    
    var body: some View {
        Form {
            ForEach(viewModel.yearMonths.indices, id:\.self) { index in
                let yearMonth = viewModel.yearMonths[index]
                NavigationLink {
                    switch viewModel.screenType {
                    case .all:
                        AllStatementScreen(yearMonth: yearMonth)
                    case .income:
                        CoreDataIncomeScreen(yearMonth: yearMonth)
                    case .expense:
                        CoreDataExpenseScreen(yearMonth: yearMonth)
                    }
                } label: {
                    YearMonthCellView(yearMonth: yearMonth)
                }
            }
            .onDelete(perform: viewModel.delete)
        }
        .onAppear(perform: viewModel.load)
        .refreshable {
            viewModel.load()
        }
        .navigationTitle("YearMonth - \(viewModel.screenType.rawValue.capitalized)")
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
            viewModel.load()
        } content: {
            switch viewModel.screenType {
            case .all:
                AddYearMonthScreen(isShowAddScreen: $viewModel.isShowAddScreen)
            case .income:
                AddIncomeScreen(income: nil) {
                    viewModel.load()
                    viewModel.isShowAddScreen.toggle()
                }
            case .expense:
                AddExpenseScreen(expense: nil) {
                    viewModel.load()
                    viewModel.isShowAddScreen.toggle()
                }
            }
            
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
