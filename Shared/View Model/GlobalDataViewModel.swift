//
//  GlobalDataViewModel.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 23/12/21.
//

import Foundation

class GlobalData: ObservableObject {
    @Published var types = Types()
    @Published var tempTypes = Types()
    @Published var yearMonths = [YearMonthModel]()
    @Published var templateModels = [TemplateModel]()
    @Published var isLoadingTypes = false
    @Published var isLoadingCheckTypes = false
    @Published var isLoadingYearMonths = false
    @Published var isLoadingTemplateModel = false
    
    @Published var isLoadingDisplay: Bool = false
    var isLoading: Bool {
        isLoadingTypes || isLoadingCheckTypes || isLoadingYearMonths || isLoadingTemplateModel || isLoadingDisplay
    }
    
    @Published var errorMessage: ErrorMessage? = nil
    @Published var isShowErrorMessage = false
    
    static let shared = GlobalData()
    let coreDataManager = CoreDataManager.shared
    
    init() {
        loadAllCoreData()
        checkTypes()
//        loadAllRemote()
    }
    
    //MARK: - CoreData
    func loadAllCoreData() {
        getTypesCoreData()
        getYearMonthCoreData()
        getTemplateModelCoreData()
        isLoadingDisplay = false
    }
    
    func getTypesCoreData() {
        isLoadingTypes = true
        coreDataManager.loadTypes { types in
            self.isLoadingTypes = false
            self.types.allTypes = Mapper.mapTypesCoreDataToLocal(types)
        }
    }
    
    func getYearMonthCoreData() {
        isLoadingYearMonths = true
        coreDataManager.loadYearMonths { yearMonths in
            self.isLoadingYearMonths = false
            self.yearMonths = Mapper.mapYearMonthListCoreDataToLocal(yearMonths)
        }
    }
    
    func getTemplateModelCoreData() {
        isLoadingTemplateModel = true
        coreDataManager.loadTempalates { templates in
            self.isLoadingTemplateModel = false
            self.templateModels = Mapper.mapTemplatesCoreDataToLocal(templates)
        }
    }
    
    
    //MARK: - Remote
    func loadAllRemote() {
        getTypesRemote()
        getYearMonthRemote()
        getTemplateModelRemote()
        isLoadingDisplay = false
    }
    
    func loadNewType() {
        types.allTypes.removeAll()
        getTypesRemote()
    }
    
    func loadNewYearMonths() {
        yearMonths.removeAll()
        getYearMonthRemote()
    }
    
    func loadNewTemplateModels() {
        templateModels.removeAll()
        getTemplateModelRemote()
    }
    
    func getTypesRemote(startCursor: String? = nil, completion: @escaping () -> Void = {}) {
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
                    self.tempTypes.allTypes = self.types.allTypes
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.getTypesRemote(startCursor: nextCursor)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func getTempTypesRemote(startCursor: String? = nil, completion: @escaping () -> Void = {}) {
        let newData = startCursor == nil
        isLoadingTypes = true
        Networking.shared.getTypes(startCursor: startCursor) { (result: Result<DefaultResponse<TypeProperty>, NetworkError>) in
            DispatchQueue.main.async {
                self.isLoadingTypes = false
                switch result {
                case .success(let data):
                    let results = Mapper.mapTypeRemoteToLocal(data.results)
                    if self.types.allTypes.isEmpty || newData {
                        self.tempTypes.allTypes = results
                    } else {
                        self.tempTypes.allTypes.append(contentsOf: results)
                    }
                    if data.hasMore {
                        if let nextCursor = data.nextCursor {
                            self.getTypesRemote(startCursor: nextCursor)
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                completion()
            }
        }
    }
    
    func getYearMonthRemote(startCursor: String? = nil, completion: (() -> Void)? = nil) {
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
                            self.getYearMonthRemote(startCursor: nextCursor)
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
    
    func getTemplateModelRemote(startCursor: String? = nil, completion: (() -> Void)? = nil, done: @escaping () -> Void = {}) {
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
                            self.getTemplateModelRemote(startCursor: nextCursor)
                        }
                    } else {
                        if let completion = completion {
                            return completion()
                        }
                    }
                case .failure(let error):
                    print(error)
                }
                done()
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
    
    //MARK: - Default Types
    
    func checkTypes() {
        if types.allTypes.isEmpty {
            isLoadingCheckTypes = true
            getTempTypesRemote {
                if !self.tempTypes.allTypes.isEmpty {
                    self.coreDataManager.batchInsertTypes(types: self.tempTypes.allTypes) { isSuccess in
                        self.isLoadingCheckTypes = false
                        if isSuccess {
                            self.getTypesCoreData()
                        }
                    }
                } else {
                    self.isLoadingCheckTypes = false
                }
            }
        }
    }
}
