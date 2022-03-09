//
//  AddSubcategoryScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddSubcategoryViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var subcategory: Subcategory
    @Published var selectedSubcategory: Subcategory
    @Published var name = ""
    @Published var category = Category(name: "", type: "")
    
    var categories: [Category] = []
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedSubcategory.name ||
        category.name != selectedSubcategory.mainCategory?.name ?? ""
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(subcategory: Subcategory?) {
        categories = coreDataManager.getCategories()
        
        if let subcategory = subcategory {
            self.subcategory = subcategory
            selectedSubcategory = subcategory
            
            name = subcategory.name
            
            if let mainCategory = categories.first(where: {$0.id == subcategory.mainCategory?.id}) {
                category = mainCategory
            }
            
            isUpdate = true
        } else {
            let defaultSubcategory = Subcategory(name: "")
            self.subcategory = defaultSubcategory
            selectedSubcategory = defaultSubcategory
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            subcategory.name = try Validation.textField(name.trimWhitespace()) 
            subcategory.mainCategory = try Validation.picker(inputName: category.name, input: category, typeError: .noCategory) as? Category
            
            if isUpdate {
                coreDataManager.updateSubcategory(subcategory)
            } else {
                coreDataManager.createSubcategory(subcategory)
            }
            completion(true)
        } catch let error {
            if let error = error as? ValidationError {
                if let errorMessage = error.errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessage = true
                }
            }
        }
    }
    
    func delete(completion: @escaping (Bool) -> Void) {
        coreDataManager.deleteSubcategory(subcategory)
        completion(true)
    }
}

struct AddSubcategoryScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddSubcategoryViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(subcategory: Subcategory? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddSubcategoryViewModel(subcategory: subcategory))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Lunch", value: $viewModel.name)
                    
                    Picker("Main Catergory", selection: $viewModel.category) {
                        ForEach(viewModel.categories, id:\.self) {
                            Text($0.name.capitalized)
                        }
                    }
                }
                
                if viewModel.isUpdate {
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
            .showErrorAlert(isShowErrorMessageAlert: $viewModel.isShowErrorMessage, errorMessage: viewModel.errorMessage)
            .discardChangesAlert(isShowAlert: $isShowDiscardAlert) {
                presentationMode.wrappedValue.dismiss()
            }
            .navigationTitle("Add Subcategory")
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
        }
    }
}

struct AddSubcategoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddSubcategoryScreen()
    }
}
