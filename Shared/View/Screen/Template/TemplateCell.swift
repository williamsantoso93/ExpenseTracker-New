//
//  TemplateCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

struct TemplateCell: View {
    var templateModel: TemplateModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("name : \(templateModel.name ?? "-")")
            Text("store : \(templateModel.store ?? "-")")
            Text("value : \((templateModel.value ?? 0).splitDigit())")
            Text("label : \(templateModel.label ?? "-")")
            Text("account : \(templateModel.account ?? "-")")
            Text("category : \(templateModel.category ?? "-")")
            Text("subcategory : \(templateModel.subcategory ?? "-")")
            Text("duration : \(templateModel.duration ?? "-")")
            Text("payment : \(templateModel.payment ?? "-")")
        }
    }
}

struct TemplateCell_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCell(templateModel: TemplateModel(blockID: "", name: nil, label: nil, account: nil, category: nil, subcategory: nil, duration: nil, payment: nil, store: nil, type: nil, value: nil, keywords: nil))
    }
}
