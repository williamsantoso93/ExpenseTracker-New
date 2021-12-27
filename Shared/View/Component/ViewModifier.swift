//
//  ViewModifier.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    var isLoading: Bool
    var isNeedDisable: Bool
    
    init(_ isLoading: Bool, isNeedDisable: Bool) {
        self.isLoading = isLoading
        self.isNeedDisable = isNeedDisable
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(isLoading && isNeedDisable)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                    }
                }
            )
    }
}

struct LoadingWithNoDataButtonViewModifier: ViewModifier {
    var isLoading: Bool
    var isShowNoData: Bool
    var action: () -> Void
    
    init(_ isLoading: Bool, isShowNoData: Bool, action: @escaping () -> Void) {
        self.isLoading = isLoading
        self.isShowNoData = isShowNoData
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
            .overlay(
                Group {
                    if isLoading {
                        ProgressView()
                    } else {
                        if isShowNoData {
                            VStack {
                                Text("No data")
                                Button("Add New Data") {
                                    action()
                                }
                            }
                        }
                    }
                }
            )
    }
}

struct ShowErrorAlertViewModifier: ViewModifier {
    @Binding var isShowErrorMessageAlert: Bool
    var errorMessage: ErrorMessage
    var action: (() -> Void)?
        
    init(isShowErrorMessageAlert: Binding<Bool>, errorMessage: ErrorMessage, action: (() -> Void)?) {
        self._isShowErrorMessageAlert = isShowErrorMessageAlert
        self.errorMessage = errorMessage
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .alert(errorMessage.title, isPresented: $isShowErrorMessageAlert) {
                Button("OK", role: .cancel) {
                    if let action = action {
                        action()
                    }
                }
            } message: {
                Text(errorMessage.message)
            }

    }
}

extension View {
    func loadingView(_ isLoading: Bool, isNeedDisable: Bool = true) -> some View {
        modifier(LoadingViewModifier(isLoading, isNeedDisable: isNeedDisable))
    }
    
    func loadingWithNoDataButton(_ isLoading: Bool, isShowNoData: Bool, action: @escaping () -> Void) -> some View {
        modifier(LoadingWithNoDataButtonViewModifier(isLoading, isShowNoData: isShowNoData, action: action))
    }
    
    func showErrorAlert(isShowErrorMessageAlert: Binding<Bool>, errorMessage: ErrorMessage, action: (() -> Void)? = nil) -> some View {
        modifier(ShowErrorAlertViewModifier(isShowErrorMessageAlert: isShowErrorMessageAlert, errorMessage: errorMessage, action: action))
    }
}
