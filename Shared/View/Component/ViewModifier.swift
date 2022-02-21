//
//  ViewModifier.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI
import Combine

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

struct NetworkErrorAlertViewModifier: ViewModifier {
    @ObservedObject private var globalData = GlobalData.shared
    var action: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .alert(globalData.errorMessage.title, isPresented: $globalData.isShowErrorMessage) {
                Button("OK", role: .cancel) {
                    if let action = action {
                        action()
                    }
                }
            } message: {
                Text(globalData.errorMessage.message)
            }
            .onReceive(globalData.$errorMessage) { errorMessage in
                if !errorMessage.message.isEmpty {
                    globalData.isShowErrorMessage = true
                }
            }
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

struct DiscardChangesAlertViewModifier: ViewModifier {
    @Binding var isShowAlert: Bool
    var discardAction: (() -> Void)?
    
    init(isShowAlert: Binding<Bool>, discardAction: (() -> Void)?) {
        self._isShowAlert = isShowAlert
        self.discardAction = discardAction
    }
    
    func body(content: Content) -> some View {
        content
            .alert("Are you sure?", isPresented: $isShowAlert) {
                Button("Discard Changes", role: .destructive) {
                    if let discardAction = discardAction {
                        discardAction()
                    }
                }
            } message: {
                Text("Do you want to dicard any changes?")
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
    
    func discardChangesAlert(isShowAlert: Binding<Bool>, discardAction: (() -> Void)?) -> some View {
        modifier(DiscardChangesAlertViewModifier(isShowAlert: isShowAlert, discardAction: discardAction))
    }
    
    func networkErrorAlert(action: (() -> Void)? = nil) -> some View {
        modifier(NetworkErrorAlertViewModifier(action: action))
    }
}
