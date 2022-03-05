//
//  AddCategoryScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddCategoryViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var category: Category
    @Published var selectedCategory: Category
    @Published var name = ""
    @Published var type = "expense"
    @Published var categoryNature: CategoryNature = CategoryNature(name: "")
    
    var categoryNatures: [CategoryNature] = []
    
    var types: [String] {[
        "income",
        "expense"
    ]}
    
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedCategory.name ||
        type != selectedCategory.type ||
        categoryNature.name != selectedCategory.nature?.name ?? ""
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(category: Category?) {
        categoryNatures = coreDataManager.getCategoryNatures()
        if let category = category {
            self.category = category
            selectedCategory = category
            
            name = category.name
            type = category.type
            
            if let categoryNature = categoryNatures.first(where: {$0.id == category.nature?.id}) {
                self.categoryNature = categoryNature
            }
            
            isUpdate = true
        } else {
            let defaultCategory = Category(
                name: "",
                type: ""
            )
            self.category = defaultCategory
            selectedCategory = defaultCategory
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            category.name = try Validation.textField(name.trimWhitespace())
            category.type = try Validation.picker(type, typeError: .noType)
            category.nature = try Validation.picker(inputName: categoryNature.name, input: categoryNature, typeError: .noCategory) as? CategoryNature
            
            if isUpdate {
                coreDataManager.updateCategory(category)
            } else {
                coreDataManager.createCategory(category)
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
        coreDataManager.deleteCategory(category)
        completion(true)
    }
}

struct AddCategoryScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddCategoryViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(category: Category? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddCategoryViewModel(category: category))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Food", value: $viewModel.name)
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(viewModel.types, id: \.self) {
                            Text($0.capitalized)
                        }
                    }
                    
                    Picker("Nature", selection: $viewModel.categoryNature) {
                        ForEach(viewModel.categoryNatures, id:\.self) {
                            Text($0.name.capitalized)
                        }
                    }
                }
                Button {
                    viewModel.categoryNature = viewModel.categoryNatures[0]
                } label: {
                    Text("Test")
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
            .navigationTitle("Add Category")
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

struct AddCategoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddCategoryScreen()
    }
}
