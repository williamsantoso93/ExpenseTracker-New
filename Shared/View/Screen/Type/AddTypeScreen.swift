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
    var refesh: () -> Void
        
    init(typeModel: TypeModel? = nil, refesh: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: AddTypeViewModel(typeModel: typeModel))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("Category", selection: $viewModel.selectedCategory) {
                    ForEach(viewModel.category, id: \.self) {
                        Text($0)
                    }
                }
                NumberTextFiedForm(title: "Name", prompt: "IPL", value: $viewModel.name)
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
                                refesh()
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        Text(viewModel.saveTitle)
                    }
                }
            }
        }
    }
}

struct AddTypeScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTypeScreen() {}
    }
}
