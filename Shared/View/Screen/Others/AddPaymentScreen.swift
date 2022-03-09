//
//  AddPaymentScreen.swift
//  ExpenseTracker
//
//  Created by William Santoso on 05/03/22.
//

import SwiftUI

class AddPaymentViewModel: AddViewModel {
    let coreDataManager = CoreDataManager.shared
    
    @Published var payment: Payment
    @Published var selectedPayment: Payment
    @Published var name = ""
    
    
    var saveTitle: String {
        isUpdate ? "Update" : "Save"
    }
    var isUpdate: Bool = false
    
    var isChanged: Bool {
        name != selectedPayment.name
    }
    
    @Published var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @Published var isShowErrorMessage = false
    
    init(payment: Payment?) {
        if let payment = payment {
            self.payment = payment
            selectedPayment = payment
            
            name = payment.name
            
            isUpdate = true
        } else {
            let defaultPayment = Payment(name: "")
            self.payment = defaultPayment
            selectedPayment = defaultPayment
        }
    }
    
    func save(completion: @escaping (Bool) -> Void) {
        do {
            payment.name = try Validation.textField(name.trimWhitespace())
            
            if isUpdate {
                coreDataManager.updatePayment(payment)
            } else {
                coreDataManager.createPayment(payment)
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
        coreDataManager.deletePayment(payment)
        completion(true)
    }
}

struct AddPaymentScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: AddPaymentViewModel
    @State private var isShowDiscardAlert = false
    var refesh: () -> Void
    
    init(payment: Payment? = nil, refesh: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: AddPaymentViewModel(payment: payment))
        self.refesh = refesh
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextFiedForm(title: "Name", prompt: "Credit Card", value: $viewModel.name)
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
            .navigationTitle("Add Payment")
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

struct AddPaymentScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddPaymentScreen()
    }
}
