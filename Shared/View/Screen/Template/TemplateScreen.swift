//
//  templateModelscreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct templateModelscreen: View {
    @ObservedObject var globalData = GlobalData.shared
    
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
                                viewModel.selectTemplate(templateModel)
                            } label: {
                                VStack(alignment: .leading) {
                                    Text("name : \(templateModel.name ?? "")")
                                    Text("value : \(templateModel.value ?? 0)")
                                    Text("duration : \(templateModel.duration ?? "")")
                                    Text("paymentVia : \(templateModel.paymentVia ?? "")")
                                    Text("types : \(templateModel.type ?? "")")
                                }
                            }
                        }
                    }
                }
            }
        }
        .loadingView(GlobalData.shared.isLoading, isNeedDisable: false)
        .searchable(text: $viewModel.searchText)
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
                        viewModel.isShowAddScreen.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedTemplate = nil
        } content: {
            AddTemplatescreen(templateModel: viewModel.selectedTemplate) {
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
