//
//  TypeScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 23/12/21.
//

import SwiftUI

struct TypeScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    var body: some View {
        Form {
            if !globalData.types.incomeTypes.isEmpty {
                Section(header: Text("incomeTypes")) {
                    ForEach(globalData.types.incomeTypes.indices, id:\.self) {index in
                        let type = globalData.types.incomeTypes[index]
                        VStack(alignment: .leading) {
                            Text(type.name)
                        }
                    }
                }
            }
            if !globalData.types.expenseTypes.isEmpty {
                Section(header: Text("expenseTypes")) {
                    ForEach(globalData.types.expenseTypes.indices, id:\.self) {index in
                        let type = globalData.types.expenseTypes[index]
                        VStack(alignment: .leading) {
                            Text(type.name)
                        }
                    }
                }
            }
            if !globalData.types.paymentTypes.isEmpty {
                Section(header: Text("paymentTypes")) {
                    ForEach(globalData.types.paymentTypes.indices, id:\.self) {index in
                        let type = globalData.types.paymentTypes[index]
                        VStack(alignment: .leading) {
                            Text(type.name)
                        }
                    }
                }
            }
            if !globalData.types.durationTypes.isEmpty {
                Section(header: Text("durationTypes")) {
                    ForEach(globalData.types.durationTypes.indices, id:\.self) {index in
                        let type = globalData.types.durationTypes[index]
                        VStack(alignment: .leading) {
                            Text(type.name)
                        }
                    }
                }
            }
        }
        .navigationTitle("Types")
    }
}

struct TypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        TypeScreen()
    }
}
