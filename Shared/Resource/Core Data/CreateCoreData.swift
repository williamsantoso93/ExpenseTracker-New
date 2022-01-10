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
}
