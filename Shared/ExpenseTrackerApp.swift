//
//  ExpenseTrackerApp.swift
//  Shared
//
//  Created by Ruangguru on 19/12/21.
//

import SwiftUI

@main
struct ExpenseTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            SummaryScreen()
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
