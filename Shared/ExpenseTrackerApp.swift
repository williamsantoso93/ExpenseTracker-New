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
    let globalData = GlobalData.shared

    var body: some Scene {
        WindowGroup {
            SummaryScreen()
#if os(iOS)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
#endif
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
