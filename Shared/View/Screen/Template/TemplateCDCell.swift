//
//  TemplateCDCell.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct TemplateCDCell: View {
    var templateModel: TemplateModelCD
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(templateModel.id.uuidString)")
            Text("name : \(templateModel.name ?? "-")")
            Text("store : \(templateModel.store ?? "-")")
            Text("value : \(templateModel.value .splitDigit())")
            Group {
                Text("duration : \(templateModel.duration?.name ?? "-")")
                Text("payment : \(templateModel.payment?.name ?? "-")")
                Text("label : \(templateModel.label?.name ?? "-")")
                Text("account : \(templateModel.account?.name ?? "-")")
                Text("category : \(templateModel.category?.name ?? "-")")
                Text("subcategory : \(templateModel.subcategory?.name ?? "-")")
            }
            Group {
                Text("date : \(templateModel.date.toString())")
                Text("dateCreated : \(templateModel.dateCreated.toString())")
                Text("dateUpdated : \(templateModel.dateUpdated.toString())")
            }
            
            //            Text("keywords : \(expense.keywords)")
        }
    }
}

struct TemplateCDCell_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCDCell(templateModel: TemplateModelCD(type: "income"))
    }
}
