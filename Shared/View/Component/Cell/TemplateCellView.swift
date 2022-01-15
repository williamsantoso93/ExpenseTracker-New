//
//  TemplateCellView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct TemplateCellView: View {
    var template: TemplateModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("notionID : \(template.notionID ?? "")")
            Text("category : \(template.category ?? "-")")
            Text("name : \(template.name ?? "-")")
            Text("store : \(template.store ?? "-")")
            Text("value : \(template.value ?? 0)")
            Text("duration : \(template.duration ?? "-")")
            Text("paymentVia : \(template.paymentVia ?? "-")")
            if let types = template.types {
                Text("types : \(types.joinedWithComma())")
            }
        }
    }
}

struct TemplateCellView_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCellView(template: TemplateModel(id: UUID().uuidString, notionID: UUID().uuidString, name: "Netflix", category: "Expense", duration: "Monthly", paymentVia: "CC BCA", store: "seakun.id", types: ["Entertaiment", "Dummy"], value: 46500, keywords: nil))
    }
}
