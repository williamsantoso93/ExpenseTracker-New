//
//  templateModelscreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct templateModelscreen: View {
    @ObservedObject var globalData = GlobalData.shared
    @State private var isShowAddScreen = false
    @State private var selectedTemplateModel: TemplateModel?
    
    @StateObject var viewModel = TemplateViewModel()
    
    var body: some View {
        Form {
            if !globalData.templateModels.isEmpty {
                ForEach(viewModel.category, id:\.self) { category in
                    let templateModels = viewModel.filterTemplate(category)
                    
                    Section(header: Text(category)) {
                        ForEach(templateModels.indices, id:\.self) { index in
                            let templateModel = templateModels[index]
                            
                            Button {
                                selectedTemplateModel = templateModel
                                if selectedTemplateModel != nil {
                                    isShowAddScreen.toggle()
                                }
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("name : \(templateModel.name ?? "")")
                                    Text("value : \(templateModel.value ?? 0)")
                                    Text("duration : \(templateModel.duration ?? "")")
                                    Text("paymentVia : \(templateModel.paymentVia ?? "")")
                                    Text("type : \(templateModel.type ?? "")")
                                }
                            }
                        }
                    }
                }
            }
        }
        .loadingView(GlobalData.shared.isLoading, isNeedDisable: false)
        .refreshable {
            GlobalData.shared.getTemplateModel()
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
            selectedTemplateModel = nil
        } content: {
            AddTemplatescreen(templateModel: selectedTemplateModel) {
                globalData.getTemplateModel()
            }
        }
    }
}

struct templateModelscreen_Previews: PreviewProvider {
    static var previews: some View {
        templateModelscreen()
    }
}
