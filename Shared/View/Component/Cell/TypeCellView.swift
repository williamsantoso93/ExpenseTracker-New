//
//  TypeCellView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct TypeCellView: View {
    var type: TypeModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(type.name)
        }
    }
}

struct TypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        TypeCellView(type: TypeModel(id: UUID().uuidString, notionID: UUID().uuidString, name: "Entertaiment", category: "expense", keywords: ""))
    }
}
