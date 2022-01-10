//
//  CreateCoreData.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 10/01/22.
//

import Foundation
import CoreData

extension CoreDataManager {
    func save(completion: () -> Void) {
        do {
            try viewContext.save()
            completion()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
}
