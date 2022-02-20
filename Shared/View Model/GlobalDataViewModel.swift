//
//  GlobalDataViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 23/12/21.
//

import Foundation
import Combine

class GlobalData: ObservableObject {
    @Published var types = Types()
    @Published var yearMonths = [YearMonth]()
    @Published var templateModels = [TemplateModel]()
    @Published var isLoadingTypes = false
    @Published var isLoadingYearMonths = false
    @Published var isLoadingTemplateModel = false
    
    @Published var isLoadingDisplay: Bool = false
    var isLoading: Bool {
        isLoadingTypes || isLoadingYearMonths || isLoadingTemplateModel || isLoadingDisplay
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    static let shared = GlobalData()
    var cancelables = Set<AnyCancellable>()
    
    init() {
        loadAll()
    }
    
    func loadAll() {
        getTypes()
        getYearMonth()
        getTemplateModel()
        isLoadingDisplay = false
    }
    
    func loadNewType() {
        types.allTypes.removeAll()
        getTypes()
    }
    
    func loadNewYearMonths() {
        yearMonths.removeAll()
        getYearMonth()
    }
    
    func loadNewTemplateModels() {
        templateModels.removeAll()
        getTemplateModel()
    }
    
    func getTypes(startCursor: String? = nil, completion: (() -> Void)? = nil) {
        let newData = startCursor == nil
        isLoadingTypes = true
        
        do {
            try Networking.shared.getTypes(startCursor: startCursor)
                .sink { completion in
                    
                } receiveValue: { data in
                    self.isLoadingTypes = false
                    let results = Mapper.mapTypeRemoteToLocal(data.results)
                    if self.types.allTypes.isEmpty || newData {
                        self.types.allTypes = results
                    } else {
                        self.types.allTypes.append(contentsOf: results)
                    }
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.getTypes(startCursor: nextCursor)
                        }
                    } else {
                        if let completion = completion {
                            return completion()
                        }
                    }
                }
                .store(in: &self.cancelables)
        } catch {
            print(error)
        }
    }
    
    func getYearMonth(startCursor: String? = nil, completion: (() -> Void)? = nil) {
        let newData = startCursor == nil
        isLoadingTypes = true
        
        do {
            try Networking.shared.getYearMonth(startCursor: startCursor)
                .sink { completion in
                    
                } receiveValue: { data in
                    self.isLoadingTypes = false
                    let results = Mapper.mapYearMonthListRemoteToLocal(data.results)
                    if self.yearMonths.isEmpty || newData {
                        self.yearMonths = results
                    } else {
                        self.yearMonths.append(contentsOf: results)
                    }
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.getYearMonth(startCursor: nextCursor)
                        }
                    } else {
                        if let completion = completion {
                            return completion()
                        }
                    }
                }
                .store(in: &self.cancelables)
        } catch {
            print(error)
        }
    }
    
    func getTemplateModel(startCursor: String? = nil, completion: (() -> Void)? = nil, done: @escaping () -> Void = {}) {
        let newData = startCursor == nil
        isLoadingTypes = true
        
        do {
            try Networking.shared.getTemplateModel(startCursor: startCursor)
                .sink { completion in
                    
                } receiveValue: { data in
                    let results = Mapper.mapTemplateModelRemoteToLocal(data.results)
                    if self.templateModels.isEmpty || newData {
                        self.templateModels = results
                    } else {
                        self.templateModels.append(contentsOf: results)
                    }
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.getTemplateModel(startCursor: nextCursor)
                        }
                    } else {
                        if let completion = completion {
                            return completion()
                        }
                    }
                }
                .store(in: &self.cancelables)
        } catch {
            print(error)
        }
    }
    
    func getYearMonthID(_ date: Date) -> String? {
        let yearMonth = yearMonths.filter { result in
            result.name == date.toYearMonthString()
        }
        
        if let id = yearMonth.first?.id {
            return id
        } else {
            return nil
        }
    }
}
