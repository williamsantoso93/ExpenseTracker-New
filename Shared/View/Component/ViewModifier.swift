//
//  ViewModifier.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    var isLoading: Bool
    
    init(_ isLoading: Bool) {
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        content
            .disabled(isLoading)
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

extension View {
    func loadingView(_ isLoading: Bool) -> some View {
        modifier(LoadingViewModifier(isLoading))
    }
    
    func loadingWithNoDataButton(_ isLoading: Bool, isShowNoData: Bool, action: @escaping () -> Void) -> some View {
        modifier(LoadingWithNoDataButtonViewModifier(isLoading, isShowNoData: isShowNoData, action: action))
    }
}
