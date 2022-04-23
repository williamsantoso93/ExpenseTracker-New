//
//  AddIncomeScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import SwiftUI

struct AddIncomeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var globalData = GlobalData.shared
    @StateObject var viewModel: AddIncomeViewModel
    var dismiss: (Income?, DismissType) -> Void
    
    @State private var isShowTypeAddScreen = false
    @State private var isShowDiscardAlert = false
    
    init(income: Income? = nil, dismiss: @escaping (Income?, DismissType) -> Void) {
        self._viewModel = StateObject(wrappedValue: AddIncomeViewModel(income: income))
        self.dismiss = dismiss
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
                            Text($0)
                        }
                    }
                    Picker("Account", selection: $viewModel.selectedAccount) {
                        ForEach(viewModel.accounts, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories, id: \.self) {
                            Text($0)
                        }
                    }
                    Picker("Subcategory", selection: $viewModel.selectedSubcategory) {
                        ForEach(viewModel.subcategories, id: \.self) {
                            Text($0)
                        }
                    }
                    .disabled(viewModel.isSubCategoryDisabled)
                    
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                    
                    VStack(alignment: .leading, spacing: 8.0) {
                        Text("Note")
                        TextField("", text: $viewModel.note)
                    }
                    .padding(.bottom, 4)
                }
                
                Section {
                    Toggle("Is Done Export", isOn: $viewModel.isDoneExport)
                    
                    Button("Share Income") {
                        viewModel.shareIncome { income in
                            let activityVC = UIActivityViewController(activityItems: [income], applicationActivities: nil)
                            
                            activityVC.excludedActivityTypes = [
                                .airDrop,
                                .addToReadingList,
                                .postToFlickr,
                                .postToVimeo,
                                .openInIBooks,
                                .print,
                                .assignToContact,
                                .saveToCameraRoll
                            ]
                            
                            UIApplication.shared.keyWindowPresentedController?.present(activityVC, animated: true) {
                                self.viewModel.copyNote()
                            }
                        }
                    }
                    
                    Button("Copy Note") {
                        viewModel.copyNote()
                    }
                } header: {
                    Text("Copy/Export")
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
                            viewModel.addTemplate()
                        } label: {
                            Text("Add Template")
                        }
                    }
                } else {
                    Section {
                        Button("Delete", role: .destructive) {
                            viewModel.delete { isSuccess in
                                if isSuccess {
                                    dismiss(nil, .refreshAll)
                                    presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                }
            }
            .loadingView(viewModel.isLoading)
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .networkErrorAlert()
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
                        viewModel.save { isSuccess, income, dismissType in
                            if isSuccess {
                                dismiss(income, dismissType)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text(viewModel.saveTitle)
                    }
                    .disabled(!viewModel.isChanged)
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
            .sheet(isPresented: $viewModel.isShowTemplateAddScreen) {
            } content: {
                AddTemplatescreen(templateModel: viewModel.templateModel) {
                    globalData.getTemplateModel(done:  {
                        viewModel.templateModels = GlobalData.shared.templateModels
                    })
                }
            }
        }
    }
}

struct AddIncomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddIncomeScreen() { _,_  in }
    }
}
