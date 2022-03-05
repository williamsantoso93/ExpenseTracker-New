//
//  OthersScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 01/03/22.
//

import SwiftUI

struct OthersScreen: View {
    @StateObject var viewModel = OthersViewModel()
    
    @State var isShowAddLabelScreen = false
    @State var selectedLabelModel: LabelModel? = nil
    
    func selectLabel(_ label: LabelModel? = nil) {
        selectedLabelModel = label
        isShowAddLabelScreen = true
    }
    
    var body: some View {
        Form {
            NavigationLink("Labels") {
                Form {
                    ForEach(viewModel.labels.indices, id:\.self) { index in
                        let label = viewModel.labels[index]
                        Button {
                            selectLabel(label)
                        } label: {
                            IdNameView(id: label.id, name: label.name)
                        }

                    }
                }
                .refreshable {
                    viewModel.getData()
                }
                .navigationTitle("Labels")
                .toolbar {
                    ToolbarItem {
                        HStack {
                            Button {
                                selectLabel()
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
                .sheet(isPresented: $isShowAddLabelScreen) {
                    selectedLabelModel = nil
                } content: {
                    AddLabelScreen(labelModel: selectedLabelModel) {
                        viewModel.getData()
                    }
                }
            }
            
            NavigationLink("Accounts") {
                Form {
                    ForEach(viewModel.accounts.indices, id:\.self) { index in
                        let account = viewModel.accounts[index]
                        
                        IdNameView(id: account.id, name: account.name)
                    }
                    .onDelete(perform: viewModel.deleteAccount)
                }
                .navigationTitle("Accounts")
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
            }
            
            NavigationLink("Payments") {
                Form {
                    ForEach(viewModel.payments.indices, id:\.self) { index in
                        let payment = viewModel.payments[index]
                        
                        IdNameView(id: payment.id, name: payment.name)
                    }
                }
                .navigationTitle("Payments")
            }
            
            NavigationLink("Stores") {
                Form {
                    ForEach(viewModel.stores.indices, id:\.self) { index in
                        let store = viewModel.stores[index]
                        
                        IdNameView(id: store.id, name: store.name)
                    }
                }
                .navigationTitle("Stores")
            }
        }
        .navigationTitle("core data")
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
