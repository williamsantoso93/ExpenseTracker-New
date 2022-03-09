//
//  AddIncomeCDScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 09/03/22.
//

import SwiftUI

struct AddIncomeCDScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel: AddIncomeCDViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(incomeCD: IncomeCD? = nil, refesh: @escaping () -> Void = {}) {
        self._viewModel = StateObject(wrappedValue: AddIncomeCDViewModel(incomeCD: incomeCD))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigitDouble(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    Picker("Label", selection: $viewModel.selectedLabel) {
                        ForEach(viewModel.labels, id: \.self) {
                            Text($0.name)
                        }
                    }
                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(viewModel.accounts, id: \.self) {
                            Text($0.name)
                        }
                    }
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) {
                            Text($0.name)
                        }
                    }
                    Picker("Subcategory", selection: $viewModel.selectedSubcategory) {
                        ForEach(viewModel.subcategories, id: \.self) {
                            Text($0.name)
                        }
                    }
                    .disabled(viewModel.isSubCategoryDisabled)
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    VStack(alignment: .leading, spacing: 2.0) {
                        Text("Note")
                        TextEditor(text: $viewModel.note)
                            .frame(height: 150.0)
                    }
                }
                
                Section {
//                        Picker("Template", selection: $viewModel.selectedTemplateIndex) {
//                            ForEach(viewModel.templateModels.indices, id: \.self) { index in
//                                let templateModel = viewModel.templateModels[index]
//                                Text(templateModel.name ?? "")
//                                    .tag(index)
//                            }
//                        }
//                        .onChange(of: viewModel.selectedTemplateIndex) { index in
//                            viewModel.applyTemplate(at: index)
//                        }
//
//                        Button {
//                            isShowTypeAddScreen.toggle()
//                        } label: {
//                            Text("Add Type")
//                        }
                    
                    Button {
//                            viewModel.addTemplate()
                    } label: {
                        Text("Add Template")
                    }
                }
                
                if !viewModel.isUpdate {
                    Section {
                        Button("Delete", role: .destructive) {
                            viewModel.delete { isSuccess in
                                if isSuccess {
                                    refesh()
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .discardChangesAlert(isShowAlert: $isShowDiscardAlert) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationTitle("Add Income")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if viewModel.isChanged {
                            isShowDiscardAlert.toggle()
                        } else {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        Text(viewModel.isChanged ? "Discard" : "Cancel")
                    }
                }
#endif
                ToolbarItem {
                    Button {
                        viewModel.save { isSuccess in
                            if isSuccess {
                                refesh()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text(viewModel.saveTitle)
                    }
                    .disabled(!viewModel.isChanged)
                }
            }
//            .sheet(isPresented: $isShowTypeAddScreen) {
//            } content: {
//                AddTypeScreen() {
//                    globalData.getTypes {
//                        viewModel.types = GlobalData.shared.types
//                    }
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowTemplateAddScreen) {
//            } content: {
//                AddTemplatescreen(templateModel: viewModel.templateModel) {
//                    globalData.getTemplateModel(done:  {
//                        viewModel.templateModels = GlobalData.shared.templateModels
//                    })
//                }
//            }
        }
    }
}

struct AddIncomeCDScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddIncomeCDScreen()
    }
}
