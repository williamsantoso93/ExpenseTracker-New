//
//  SelectUsercreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 15/01/22.
//

import SwiftUI

struct SelectUsercreen: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = SelectUserViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Button("William") {
                    viewModel.setUser(.william)
                    presentationMode.wrappedValue.dismiss()
                }
                Button("Paramitha") {
                    viewModel.setUser(.paramitha)
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .loadingView(viewModel.isLoading)
            .navigationTitle("Select User")
        }
    }
}

struct SelectUserScreen_Previews: PreviewProvider {
    static var previews: some View {
        SelectUsercreen()
    }
}
