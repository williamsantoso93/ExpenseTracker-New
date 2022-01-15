//
//  CreateCoreData.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func save(completion: (Bool) -> Void) {
        do {
            try viewContext.save()
            completion(true)
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
            completion(false)
        }
    }
    
    func createYearMonth(using date: Date) -> YearMonth? {
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
        do {
            try viewContext.save()
            return getYearMonths(by: date)
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
            return nil
        }
    }
    
    func batchInsertTypes(types: [TypeModel], completion: (Bool) -> Void) {
        for type in types {
            let newType = NSManagedObject(entity: NSEntityDescription.entity(forEntityName: "TypeData", in: viewContext)!, insertInto: viewContext)
            newType.setValue(UUID(), forKey: "id")
            newType.setValue(type.notionID, forKey: "notionID")
            newType.setValue(type.name, forKey: "name")
            newType.setValue(type.category, forKey: "category")
        }
        save { isSuccess in
            completion(isSuccess)
        }
    }
    
//    func importProducts() {
//        ProductAPI.getAll { result in
//            switch result {
//            case .success(let products):
//                self.persistenceController.container.performBackgroundTask { context in
//                    context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//                    let batchInsert = NSBatchInsertRequest(entityName: "Product", objects: products)
//                    do {
//                        let result = try context.execute(batchInsert) as! NSBatchInsertResult
//                        print(result)
//                    }
//                    catch {
//                        let nsError = error as NSError
//                        // TODO: handle errors
//                    }
//                    DispatchQueue.main.async {
//                        objectWillChange.send()
//                        // TODO: handle errors
//                        try? resultsController.performFetch()
//                    }
//                }
//            }
//        }
//    }
}
