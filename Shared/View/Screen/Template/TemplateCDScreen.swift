//
//  TemplateCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct TemplateCDScreen: View {
    @StateObject private var viewModel = TemplateCDViewModel()
    
    var body: some View {
        Form {
            if !viewModel.templateModels.isEmpty {
                ForEach(viewModel.category, id:\.self) { category in
                    let templateModels = viewModel.filterTemplate(category)
                    
                    Section(header: Text(category.capitalized)) {
                        ForEach(templateModels.indices, id:\.self) { index in
                            let templateModel = templateModels[index]
                            
                            Button {
                                viewModel.selectTemplate(templateModel)
                            } label: {
                                TemplateCDCell(templateModel: templateModel)
                            }
                        }
                    }
                }
            }
        }
        .searchable(text: $viewModel.searchText)
        .refreshable {
            viewModel.loadData()
        }
        .navigationTitle("Template")
        .toolbar {
            ToolbarItem {
                HStack {
#if os(iOS)
                    EditButton()
#endif
                    Button {
                        viewModel.selectTemplate()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowAddScreen) {
            viewModel.selectedTemplate = nil
        } content: {
            AddTemplateCDScreen(templateModelCD: viewModel.selectedTemplate) {
                viewModel.loadData()
            }
        }
    }
}

struct TemplateCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        TemplateCDScreen()
    }
}
