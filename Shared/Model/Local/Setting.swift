//
//  Setting.swift
//  ExpenseTracker
//
//  Created by Ruangguru on 26/12/21.
//

import Foundation

// MARK: - TemplateModel
struct TemplateModel: Codable, Hashable {
    internal init(blockID: String, name: String? = nil, label: String? = nil, account: String? = nil, category: String? = nil, subcategory: String? = nil, duration: String? = nil, payment: String? = nil, store: String? = nil, type: String? = nil, value: Double? = nil, keywords: String? = nil) {
        self.blockID = blockID
        self.name = name
        self.label = label
        self.account = account
        self.category = category
        self.subcategory = subcategory
        self.duration = duration
        self.payment = payment
        self.store = store
        self.type = type
        self.value = value
        self.keywords = keywords
    }
    
    var blockID: String
    var name: String?
    var label, account, category, subcategory, duration, payment, store: String?
    var type: String?
    var value: Double?
    var keywords: String?
    
}

// MARK: - TemplateModelCD
struct TemplateModelCD: Codable {
    var id: UUID = UUID()
    var name: String?
    var value: Double = 0
    var label: LabelModel?
    var account: Account?
    var category: Category?
    var subcategory: Subcategory?
    var duration: Duration?
    var payment: Payment?
    var store: String?
    var date: Date = Date()
    var dateCreated: Date = Date()
    var dateUpdated: Date = Date()
    var type: String
}
