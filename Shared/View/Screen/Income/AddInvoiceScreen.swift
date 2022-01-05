//
//  AddInvoiceScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import SwiftUI

struct AddInvoiceScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel: AddIncomeViewModel
    var refesh: () -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowTemplateAddScreen = false
    
    init(income: Income? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddIncomeViewModel(income: income))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    NumberTextFiedForm(title: "Value", prompt: "50000".splitDigit(), value: $viewModel.valueString)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                    MultiPickerFormView("Type(s)", items: viewModel.incomeType, selectedItems: $viewModel.selectedTypes)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    VStack(alignment: .leading, spacing: 2.0) {
                        Text("Note")
                        TextEditor(text: $viewModel.note)
                            .frame(height: 150.0)
                    }
                }
                
                if !viewModel.isUpdate {
                    Section {
                        Picker("Template", selection: $viewModel.selectedTemplateIndex) {
                            ForEach(viewModel.templateModels.indices, id: \.self) { index in
                                let templateModel = viewModel.templateModels[index]
                                Text(templateModel.name ?? "")
                                    .tag(index)
                            }
                        }
                        .onChange(of: viewModel.selectedTemplateIndex) { index in
                            viewModel.applyTemplate(at: index)
                        }
                        
                        Button {
                            isShowTypeAddScreen.toggle()
                        } label: {
                            Text("Add Type")
                        }
                        
                        Button {
                            isShowTemplateAddScreen.toggle()
                        } label: {
                            Text("Add Template")
                        }
                    }
                } else {
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
            .loadingView(viewModel.isLoading)
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .navigationTitle("Add Income")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Text("Cancel")
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
                }
            }
            .sheet(isPresented: $isShowTypeAddScreen) {
            } content: {
                AddTypeScreen() {
                    globalData.getTypes {
                        viewModel.types = GlobalData.shared.types
                    }
                }
            }
            .sheet(isPresented: $isShowTemplateAddScreen) {
            } content: {
                AddTemplatescreen() {
                    globalData.getTemplateModel(done:  {
                        viewModel.templateModels = GlobalData.shared.templateModels
                    })
                }
            }
        }
    }
}

struct AddInvoiceScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddInvoiceScreen() {}
    }
}
