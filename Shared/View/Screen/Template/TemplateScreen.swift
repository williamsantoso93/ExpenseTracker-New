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
    @State private var selectedTemplate: TemplateModel?
    
    @StateObject var viewModel = TemplateViewModel()
    
    var body: some View {
        Form {
            if !globalData.templateModels.isEmpty {
                ForEach(viewModel.category, id:\.self) { category in
                    let templates = viewModel.filterTemplate(category)
                    
                    Section(header: Text(category)) {
                        ForEach(templates.indices, id:\.self) { index in
                            let templateExpense = templates[index]
                            
                            Button {
                                selectedTemplate = templateExpense
                                if selectedTemplate != nil {
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
