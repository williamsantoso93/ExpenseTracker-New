//
//  DummyTwoScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by William Santoso on 23/02/22.
//

import SwiftUI

class DummyTwoViewModel: ObservableObject {
    let coreDataManager = CoreDataManager.shared
    @Published var accounts: [Account] = []
    @Published var categories: [Category] = []
    @Published var categoryNatures: [CategoryNature] = []
    @Published var subcategories: [Subcategory] = []
    @Published var categoriesEntity: [CategoryEntity] = []
    
    init() {
        getData()
    }
    
    func getData() {
        accounts = coreDataManager.getAccounts()
        categories = coreDataManager.getCategories()
        categoryNatures = coreDataManager.getCategoryNatures()
        subcategories = coreDataManager.getSubcategories()
        categoriesEntity = coreDataManager.getCategoryEntities()
    }
    
    func createAccount() {
        let newAccount = Account(name: "Account \(Int.random(in: 0..<100))")
        
        coreDataManager.createAccount(newAccount)
        getData()
    }
    
    func deleteAccount(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let account = accounts[index]
        coreDataManager.deleteAccount(account)
        getData()
    }
    
    let types = ["expense", "income"]
    
    func createCategory() {
        let newCategory = Category(name: "Category \(Int.random(in: 0..<100))", type: types[Int.random(in: 0...1)], nature: categoryNatures[Int.random(in: categoryNatures.indices)])
        
        coreDataManager.createCategory(newCategory)
        getData()
    }
    
    func deleteCategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let category = categories[index]
        coreDataManager.deleteCategory(category)
        getData()
    }
        
    func createSubcategory() {
        let newSubcategory = Subcategory(name: "Subcategory \(Int.random(in: 0..<100))", mainCategory: categories[Int.random(in: categories.indices)])
        
        coreDataManager.createSubcategory(newSubcategory)
//        coreDataManager.createSubcategory(newSubcategory, mainCategoryEntity: categoriesEntity[Int.random(in: categoriesEntity.indices)])
        getData()
    }
    
    func deleteSubcategory(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let subcategory = subcategories[index]
        coreDataManager.deleteSubcategory(subcategory)
        getData()
    }
    
    let natures = ["must", "need", "want"]
    
    var count = 0
    
    func createCategoryNature() {
        guard count < 3 else { return }
        let newCategoryNature = CategoryNature(name: natures[count])
        
        coreDataManager.createCategoryNature(newCategoryNature)
        getData()
        count+=1
    }
    
    func deleteCategoryNature(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let categoryNature = categoryNatures[index]
        coreDataManager.deleteCategoryNature(categoryNature)
        getData()
    }
}

struct IdNameView: View {
    var id: UUID
    var name: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("id: \(id.uuidString)")
            Text("name: \(name)")
        }
    }
}

struct DummyTwoScreen: View {
    @StateObject var viewModel = DummyTwoViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                NavigationLink("Accounts") {
                    Form {
                        ForEach(viewModel.accounts.indices, id:\.self) { index in
                            let account = viewModel.accounts[index]
                            
                            IdNameView(id: account.id, name: account.name)
                        }
                        .onDelete(perform: viewModel.deleteAccount)
                    }
                    .navigationTitle("Accounts")
                    .toolbar {
                        ToolbarItem {
                            HStack {
                                EditButton()
                                Button {
                                    viewModel.getData()
                                } label: {
                                    Text("get")
                                }
                                
                                Button {
                                    viewModel.createAccount()
                                } label: {
                                    Text("add")
                                }
                            }
                        }
                    }
                }
                
                NavigationLink("Categories") {
                    Form {
                        ForEach(viewModel.categories.indices, id:\.self) { index in
                            let category = viewModel.categories[index]
                            
                            VStack(alignment: .leading) {
                                IdNameView(id: category.id, name: category.name)
                                Text("type: \(category.type)")
                                
                                Text("categoryNature: \(category.nature?.name ?? "")")
                                
                                Text("subcategoryOf:")
                                    .padding(.top, 8)
                                VStack(alignment: .leading) {
                                    ForEach(category.subcategoryOf.indices, id:\.self) { index in
                                        let subcategoryOf = category.subcategoryOf[index]
                                        
                                        Text("- \(subcategoryOf.name)")
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .onDelete(perform: viewModel.deleteCategory)
                    }
                    .navigationTitle("Categories")
                    .toolbar {
                        ToolbarItem {
                            HStack {
                                EditButton()
                                Button {
                                    viewModel.getData()
                                } label: {
                                    Text("get")
                                }
                                
                                Button {
                                    viewModel.createCategory()
                                } label: {
                                    Text("add")
                                }
                            }
                        }
                    }
                }
                
                NavigationLink("Category Natures") {
                    Form {
                        ForEach(viewModel.categoryNatures.indices, id:\.self) { index in
                            let categoryNature = viewModel.categoryNatures[index]
                            
                            VStack(alignment: .leading) {
                                IdNameView(id: categoryNature.id, name: categoryNature.name)
                                
                                Text("categories:")
                                VStack(alignment: .leading) {
                                    ForEach(categoryNature.categories.indices, id:\.self) { index in
                                        let category = categoryNature.categories[index]
                                        
                                        Text("- \(category.name)")
                                    }
                                }
                                .padding(.leading, 8)
                            }
                        }
                        .onDelete(perform: viewModel.deleteCategoryNature)
                    }
                    .navigationTitle("Category Natures")
                    .toolbar {
                        ToolbarItem {
                            HStack {
                                EditButton()
                                Button {
                                    viewModel.getData()
                                } label: {
                                    Text("get")
                                }
                                
//                                Button {
//                                    viewModel.createCategoryNature()
//                                } label: {
//                                    Text("add")
//                                }
                            }
                        }
                    }
                }
                
                NavigationLink("Subcategories") {
                    Form {
                        ForEach(viewModel.subcategories.indices, id:\.self) { index in
                            let subcategory = viewModel.subcategories[index]
                            
                            VStack(alignment: .leading) {
                                IdNameView(id: subcategory.id, name: subcategory.name)
                                Text("mainCategory: \(subcategory.mainCategory?.name ?? "-")")
                            }
                        }
                        .onDelete(perform: viewModel.deleteSubcategory)
                    }
                    .navigationTitle("Subcategories")
                    .toolbar {
                        ToolbarItem {
                            HStack {
                                EditButton()
                                Button {
                                    viewModel.getData()
                                } label: {
                                    Text("get")
                                }
                                
                                Button {
                                    viewModel.createSubcategory()
                                } label: {
                                    Text("add")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("core data")
            .toolbar {
                ToolbarItem {
                    HStack {
                        Button {
                            viewModel.getData()
                        } label: {
                            Text("get")
                        }
                    }
                }
            }
        }
    }
}

struct DummyTwoScreen_Previews: PreviewProvider {
    static var previews: some View {
        DummyTwoScreen()
    }
}
