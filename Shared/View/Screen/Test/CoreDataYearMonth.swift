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
    
    struct DisplayYearMonth {
        let year: String
        let yearMonths: [YearMonthModel]
    }
    
    var years: [String] {
        let years = yearMonths.map { result in
            result.year
        }
        return Array(Set(years))
    }
    
    var displayYearMonths: [DisplayYearMonth] {
        var displayYearMonths = [DisplayYearMonth]()
        
        for year in years {
            let yearMonths = getYearMonths(year: year)
            displayYearMonths.append(DisplayYearMonth(year: year, yearMonths: yearMonths))
        }
        
        return displayYearMonths.sorted {
            $0.year < $1.year
        }
    }
    
    func getYearMonths(year: String) -> [YearMonthModel] {
        let filteredYearMonths = yearMonths.filter { result in
            result.year == year
        }
        
        return filteredYearMonths
    }
    
    init(screenType: StatementType) {
        self.screenType = screenType
    }
    
    func delete(_ yearMonth: YearMonthModel) {
        do {
            try CoreDataManager.shared.deleteYearMonth(yearMonth)
            if let index = getYearMonthIndex(from: yearMonth.id) {
                self.yearMonths.remove(at: index)
            }
            load()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getYearMonthIndex(from id: String) -> Int? {
        yearMonths.firstIndex { result in
            result.id == id
        }
    }
    
    func load() {
        GlobalData.shared.getYearMonthCoreData()
        yearMonths = GlobalData.shared.yearMonths
    }
}

struct CoreDataYearMonth: View {
    @StateObject var viewModel: CoreDataYearMonthViewModel
    
    init(screenType: StatementType = .all) {
        _viewModel = StateObject(wrappedValue: CoreDataYearMonthViewModel(screenType: screenType))
    }
    
    var body: some View {
        Form {
            if !viewModel.displayYearMonths.isEmpty {
                ForEach(viewModel.displayYearMonths.indices, id:\.self) {index in
                    let displayYearMonth = viewModel.displayYearMonths[index]
                    
                    Section(header: Text(displayYearMonth.year)) {
                        ForEach(displayYearMonth.yearMonths.indices, id:\.self) { index in
                            let yearMonth = displayYearMonth.yearMonths[index]
                            
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
                        .onDelete { offsets in
                            offsets.forEach { index in
                                viewModel.delete(displayYearMonth.yearMonths[index])
                            }
                        }
                    }
                }
            }
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
                        
                        _ = Mapper.yearMonthLocalToCoreData(yearMonth)
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
