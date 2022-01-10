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
    let coreDataManager = CoreDataManager.shared
    let globalData = GlobalData.shared

    var body: some Scene {
        WindowGroup {
            SummaryScreen()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environment(\.managedObjectContext, coreDataManager.presistentContainer.viewContext)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
