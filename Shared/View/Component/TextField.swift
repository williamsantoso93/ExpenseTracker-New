//
//  TextField.swift
//  ExpenseTracker (iOS)
//
//  Created by Ruangguru on 26/12/21.
//

import SwiftUI

struct TextFiedForm: View {
    var title: String
    var prompt: String = ""
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(title)
            TextField(prompt, text: $value)
                .multilineTextAlignment(.trailing)
        }
    }
}

struct NumberTextFiedForm: View {
    var title: String
    var prompt: String = ""
    @Binding var value: String
    
    var body: some View {
        TextFiedForm(title: title, prompt: prompt, value: $value)
            .onChange(of: value, perform: { value in
                self.value = value.splitDigitDouble()
            })
#if os(iOS)
            .keyboardType(.decimalPad)
#endif
    }
}
