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
        
        let yearMonthCD = Mapper.yearMonthLocalToCoreData(yearMonth)
        do {
            try viewContext.save()
            return getYearMonths(by: date)
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
            return nil
        }
    }
}
