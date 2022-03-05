//
//  OthersScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

struct OthersScreen: View {
    @StateObject var viewModel = OthersViewModel()
    
    var body: some View {
        Form {
            NavigationLink("Labels") {
                Form {
                    ForEach(viewModel.labels.indices, id:\.self) { index in
                        let label = viewModel.labels[index]
                        Button {
                            viewModel.selectLabel(label)
                        } label: {
                            IdNameView(id: label.id, name: label.name)
                        }
                    }
                    .onDelete(perform: viewModel.deleteLabel)
                }
                .refreshable {
                    viewModel.getData()
                }
                .navigationTitle("Labels")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectLabel()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddLabelScreen) {
                    viewModel.selectedLabelModel = nil
                } content: {
                    AddLabelScreen(labelModel: viewModel.selectedLabelModel) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Accounts") {
                Form {
                    ForEach(viewModel.accounts.indices, id:\.self) { index in
                        let account = viewModel.accounts[index]
                        
                        Button {
                            viewModel.selectAccount(account)
                        } label: {
                            IdNameView(id: account.id, name: account.name)
                        }
                    }
                    .onDelete(perform: viewModel.deleteAccount)
                }
                .navigationTitle("Accounts")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectAccount()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddAccountScreen) {
                    viewModel.selectedAccount = nil
                } content: {
                    AddAccountScreen(account: viewModel.selectedAccount) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Categories") {
                Form {
                    ForEach(viewModel.categories.indices, id:\.self) { index in
                        let category = viewModel.categories[index]
                        
                        Button {
                            viewModel.selectCategory(category)
                        } label: {
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
                    }
                    .onDelete(perform: viewModel.deleteCategory)
                }
                .navigationTitle("Categories")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectCategory()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddCategoryScreen) {
                    viewModel.selectedCategory = nil
                } content: {
                    AddCategoryScreen(category: viewModel.selectedCategory) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Category Natures") {
                Form {
                    ForEach(viewModel.categoryNatures.indices, id:\.self) { index in
                        let categoryNature = viewModel.categoryNatures[index]
                        
                        Button {
                            viewModel.selectCategoryNature(categoryNature)
                        } label: {
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
                    }
                    .onDelete(perform: viewModel.deleteCategoryNature)
                }
                .navigationTitle("Category Natures")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectCategoryNature()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddCategoryNatureScreen) {
                    viewModel.selectedCategoryNature = nil
                } content: {
                    AddCategoryNatureScreen(categoryNature: viewModel.selectedCategoryNature) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Subcategories") {
                Form {
                    ForEach(viewModel.subcategories.indices, id:\.self) { index in
                        let subcategory = viewModel.subcategories[index]
                        
                        Button {
                            viewModel.selectSubcategory(subcategory)
                        } label: {
                        VStack(alignment: .leading) {
                            IdNameView(id: subcategory.id, name: subcategory.name)
                            Text("mainCategory: \(subcategory.mainCategory?.name ?? "-")")
                        }
                        }
                    }
                    .onDelete(perform: viewModel.deleteSubcategory)
                }
                .navigationTitle("Subcategories")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectSubcategory()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddSubcategoryScreen) {
                    viewModel.selectedSubcategory = nil
                } content: {
                    AddSubcategoryScreen(subcategory: viewModel.selectedSubcategory) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Durations") {
                Form {
                    ForEach(viewModel.durations.indices, id:\.self) { index in
                        let duration = viewModel.durations[index]
                        
                        Button {
                            viewModel.selectDuration(duration)
                        } label: {
                        IdNameView(id: duration.id, name: duration.name)
                        }
                    }
                    .onDelete(perform: viewModel.deleteDuration)
                }
                .navigationTitle("Durations")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectDuration()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddDurationScreen) {
                    viewModel.selectedDuration = nil
                } content: {
                    AddDurationScreen(duration: viewModel.selectedDuration) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Payments") {
                Form {
                    ForEach(viewModel.payments.indices, id:\.self) { index in
                        let payment = viewModel.payments[index]
                        
                        Button {
                            viewModel.selectPayment(payment)
                        } label: {
                        IdNameView(id: payment.id, name: payment.name)
                        }
                    }
                    .onDelete(perform: viewModel.deletePayment)
                }
                .navigationTitle("Payments")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectPayment()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddPaymentScreen) {
                    viewModel.selectedPayment = nil
                } content: {
                    AddPaymentScreen(payment: viewModel.selectedPayment) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Stores") {
                Form {
                    ForEach(viewModel.stores.indices, id:\.self) { index in
                        let store = viewModel.stores[index]
                        
                        Button {
                            viewModel.selectStore(store)
                        } label: {
                        VStack(alignment: .leading) {
                            IdNameView(id: store.id, name: store.name)
                            Text("isHaveMultipleStore: \(store.isHaveMultipleStore ? "True" : "False")")
                        }
                        }
                    }
                    .onDelete(perform: viewModel.deleteStore)
                }
                .navigationTitle("Stores")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                viewModel.selectStore()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $viewModel.isShowAddStoreScreen) {
                    viewModel.selectedStore = nil
                } content: {
                    AddStoreScreen(store: viewModel.selectedStore) {
                        viewModel.getData()
                    }
                }
            }
        }
        .navigationTitle("Others")
        .refreshable {
            viewModel.getData()
        }
    }
}

struct OthersScreen_Previews: PreviewProvider {
    static var previews: some View {
        OthersScreen()
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
