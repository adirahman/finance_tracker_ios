//
//  Transaction.swift
//  FinanceTracker
//
//  Created by adira on 25/03/25.
//

import Foundation

struct Transaction: Identifiable, Codable{
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let isExpense: Bool
    
    enum CodingKeys: String, CodingKey{
        case id, title, amount, date, isExpense
    }
}


