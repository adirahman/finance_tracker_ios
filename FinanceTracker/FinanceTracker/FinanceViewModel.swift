//
//  FinanceViewModel.swift
//  FinanceTracker
//
//  Created by adira on 25/03/25.
//

import Foundation

class FinanceViewModel: ObservableObject{
    @Published var transactions: [Transaction]{
        didSet{
            saveTransactions()
        }
    }
    @Published var newTransactionTitle: String = ""
    @Published var newTransactionAmount: String = ""
    @Published var isExpense:Bool = true
    
    init(){
        self.transactions = FinanceViewModel.loadTransactions()
    }
    
    // Memuat transaksi dari UserDefaults
        private static func loadTransactions() -> [Transaction] {
            guard let data = UserDefaults.standard.data(forKey: "transactions"),
                  let savedTransactions = try? JSONDecoder().decode([Transaction].self, from: data) else {
                return []
            }
            return savedTransactions
    }
    
    // Menyimpan transaksi ke UserDefaults
        private func saveTransactions() {
            if let encodedData = try? JSONEncoder().encode(transactions) {
                UserDefaults.standard.set(encodedData, forKey: "transactions")
            }
        }
    func deleteTransaction(withId id:UUID){
        transactions.removeAll{ $0.id == id}
    }
    
    var totalIncome: Double {
        transactions
            .filter { !$0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double{
        transactions
            .filter { $0.isExpense }
            .reduce(0) { $0 + $1.amount }
    }
    
    var balance: Double{
        totalIncome - totalExpense
    }
    
    func addTransactions(){
        guard let amount = Double(newTransactionAmount),
              !newTransactionTitle.isEmpty else{
            return
        }
        
        let transaction = Transaction(
            title: newTransactionTitle,
            amount: amount,
            date:Date(),
            isExpense: isExpense
        )
        
        transactions.append(transaction)
        resetInputFields()
    }
    

    
    private func resetInputFields(){
        newTransactionTitle = ""
        newTransactionAmount = ""
    }
}
