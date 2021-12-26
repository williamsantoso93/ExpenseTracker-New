//
//  TemplateScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct TemplateScreen: View {
    @ObservedObject var globalData = GlobalData.shared
    @State private var isShowAddScreen = false
    @State private var selectedTemplate: TemplateExpense?
    
//    @StateObject var viewModel = TypeViewModel()
    
    var body: some View {
        Form {
            if !globalData.templateExpenses.isEmpty {
                ForEach(globalData.templateExpenses.indices, id:\.self) {index in
                    let templateExpense = globalData.templateExpenses[index]
                    
                    Button {
                        selectedTemplate = templateExpense
                        if let selectedTemplate = selectedTemplate {
                            isShowAddScreen.toggle()
                        }
                    } label: {
                        VStack(alignment: .leading) {
                            Text("name : \(templateExpense.name ?? "")")
                            Text("value : \(templateExpense.value ?? 0)")
                            Text("duration : \(templateExpense.duration ?? "")")
                            Text("paymentVia : \(templateExpense.paymentVia ?? "")")
                            Text("type : \(templateExpense.type ?? "")")
                        }
                    }
                }
            }
        }
        .loadingView(GlobalData.shared.isLoading, isNeedDisable: false)
        .refreshable {
            GlobalData.shared.getTemplateExpense()
        }
        .navigationTitle("Template")
        .toolbar {
            ToolbarItem {
                HStack {
#if os(iOS)
                    EditButton()
#endif
                    
                    Button {
                        isShowAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowAddScreen) {
            selectedTemplate = nil
        } content: {
            AddTemplateScreen(templateExpense: selectedTemplate) {
                globalData.getTemplateExpense()
            }
        }
    }
}

struct TemplateScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateScreen()
    }
}
