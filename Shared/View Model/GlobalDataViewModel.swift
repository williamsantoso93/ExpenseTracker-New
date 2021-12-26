//
//  GlobalDataViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 23/12/21.
//

import Foundation

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
    
    static let shared = GlobalData()
    
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
    
    func getTypes(startCursor: String? = nil) {
        let newData = startCursor == nil
        isLoadingTypes = true
        Networking.shared.getTypes(startCursor: startCursor) { (result: Result<DefaultResponse<TypeProperty>, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoadingTypes = false
                switch result {
                case .success(let data):
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
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getYearMonth(startCursor: String? = nil, completion: (() -> Void)? = nil) {
        let newData = startCursor == nil
        isLoadingYearMonths = true
        Networking.shared.getYearMonth(startCursor: startCursor) { (result: Result<DefaultResponse<YearMonthProperty>, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoadingYearMonths = false
                switch result {
                case .success(let data):
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
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    func getTemplateModel(startCursor: String? = nil, completion: (() -> Void)? = nil) {
        let newData = startCursor == nil
        isLoadingTemplateModel = true
        Networking.shared.getTemplateModel(startCursor: startCursor) { (result: Result<DefaultResponse<TemplateModelProperty>, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoadingTemplateModel = false
                switch result {
                case .success(let data):
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
                case .failure(let error):
                    print(error)
                }
            }
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
