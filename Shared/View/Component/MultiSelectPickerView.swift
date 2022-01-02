//
//  MultiSelectPickerView.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 03/01/22.
//

import SwiftUI

struct MultiPickerFormView: View {
    var title: String
    var items: [String]
    @Binding var selectedItems: [String]
    
    init(_ title: String, items: [String], selectedItems: Binding<[String]>) {
        self.title = title
        self.items = items
        self._selectedItems = selectedItems
    }
    
    var body: some View {
        NavigationLink {
            MultiSelectPickerView(items: items, selectedItems: $selectedItems)
        } label: {
            TextValueForm(title: title, value: selectedItems.joined(separator: ", "))
        }
    }
}

struct MultiSelectPickerView: View {
    var items: [String]
    @Binding var selectedItems: [String]
    
    var body: some View {
        List {
            ForEach(self.items, id: \.self) { item in
                CheckListButton(title: item, isSelected: selectedItems.contains(item)) {
                    if selectedItems.contains(item) {
                        selectedItems.removeAll(where: { $0 == item })
                    }
                    else {
                        selectedItems.append(item)
                    }
                }
            }
        }
    }
}

struct MultiSelectPickerView_Previews: PreviewProvider {
    static let items = ["Food", "Drink", "Utilities" ]
    @State static var selectedItems : [String] = []
    
    static var previews: some View {
        NavigationView {
            Form {
                MultiPickerFormView("Type", items: items, selectedItems: $selectedItems)
            }
        }
    }
}

struct TextValueForm: View {
    var title: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct CheckListButton: View {
    var title: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}
