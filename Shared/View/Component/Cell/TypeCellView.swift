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
            Text("id : \(type.id)")
            Text("notionID : \(type.notionID ?? "-")")
            Text("name : \(type.name)")
            Text("category : \(type.category)")
        }
    }
}

struct TypeCellView_Previews: PreviewProvider {
    static var previews: some View {
        TypeCellView(type: TypeModel(id: UUID().uuidString, notionID: UUID().uuidString, name: "Entertaiment", category: "expense", keywords: ""))
    }
}
