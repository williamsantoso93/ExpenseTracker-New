//
//  YearMonthCellView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct YearMonthCellView: View {
    var yearMonth: YearMonthModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id : \(yearMonth.id)")
            Text("notionID : \(yearMonth.notionID ?? "-")")
            Text("name : \(yearMonth.name)")
            Text("year : \(yearMonth.year)")
            Text("month : \(yearMonth.month)")
        }
    }
}

struct YearMonthCellView_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthCellView(yearMonth: Dummy.yearMonth)
    }
}
