//
//  SummaryScreen.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 20/12/21.
//

import SwiftUI

struct SummaryScreen: View {
    @ObservedObject private var globalData = GlobalData.shared
    @State private var isLoading = false
    @State private var isShowErrorMessageAlert = false
    @State var errorMessage: ErrorMessage = ErrorMessage(title: "", message: "")
    @StateObject var viewModel = SummaryViewModel()
    
    var body: some View {
        NavigationView{
            Form {
                NavigationLink("YearMonth") {
                    YearMonthScreen()
                }
                NavigationLink("Income") {
                    IncomeScreen()
                }
                NavigationLink("Expense") {
                    ExpenseScreen()
                }
                NavigationLink("Type") {
                    TypeScreen()
                }
                NavigationLink("Template") {
                    templateModelscreen()
                }

            }
            .loadingView(globalData.isLoading, isNeedDisable: false)
            .navigationTitle("Summary")
            .showErrorAlert(isShowErrorMessageAlert: $isShowErrorMessageAlert, errorMessage: errorMessage)
            .onReceive(globalData.$errorMessage) { errorMessage in
                if let errorMessage = errorMessage {
                    self.errorMessage = errorMessage
                    isShowErrorMessageAlert = true
                }
            }
            .overlay() {
                VStack {
                    Spacer()
                     
                    Color.clear
                        .contentShape(Rectangle())
                        .onLongPressGesture(minimumDuration: 2) {
                            viewModel.isSelectUser = true
                        }
                        .frame(height: 44)
                }
            }
        }
        .refreshable {
            globalData.loadAll()
        }
        .fullScreenCover(isPresented: $viewModel.isSelectUser) {
            
        } content: {
            SelectUsercreen()
        }

    }
}

struct SummaryScreen_Previews: PreviewProvider {
    static var previews: some View {
        SummaryScreen()
    }
}
