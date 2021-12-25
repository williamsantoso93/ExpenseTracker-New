//
//  AddTypeScreen.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 25/12/21.
//

import SwiftUI

struct AddTypeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddTypeViewModel
        
    init(typeModel: TypeModel? = nil) {
        self._viewModel = StateObject(wrappedValue: AddTypeViewModel(typeModel: typeModel))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.category, id: \.self) {
                        Text($0)
                    }
                }
                TextFiedForm(title: "Name", prompt: "IPL", value: $viewModel.name)
            }
            .navigationTitle("Add")
            .navigationBarTitleDisplayMode(.inline)
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
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text("Save")
                    }
                }
            }
        }
    }
}

struct AddTypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTypeScreen()
    }
}
