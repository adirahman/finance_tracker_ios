//
//  ContentView.swift
//  FinanceTracker
//
//  Created by adira on 25/03/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = FinanceViewModel()
    @FocusState private var isInputActive: Bool
    @State private var showingDeleteAlert = false
    @State private var transactionToDelete: UUID?
    
    var body: some View {
        NavigationView{
            VStack{
                //Summary Section
                VStack(spacing: 10){
                    Text("Balance: IDR \(viewModel.balance, specifier: "%.2f")")
                        .font(.title2)
                        .foregroundColor(viewModel.balance >= 0 ? .green : .red)
                    
                    HStack {
                        Text("Income: IDR \(viewModel.totalIncome, specifier: "%.2f")")
                            .foregroundColor(.green)
                        Spacer()
                        Text("Expense: IDR \(viewModel.totalExpense, specifier: "%.2f")")
                            .foregroundColor(.red)
                        }
                    .font(.subheadline)
                }
                .padding()
                
                //Input Section
                VStack(spacing: 15){
                    TextField("Description", text: $viewModel.newTransactionTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    
                    TextField("Amount", text: $viewModel.newTransactionAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                        .focused($isInputActive)
                    
                    Picker("Type", selection: $viewModel.isExpense){
                        Text("Expense").tag(true)
                        Text("Income").tag(false)
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    Button("Add Transaction"){
                        viewModel.addTransactions()
                        isInputActive = false
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(Color.white)
                    .cornerRadius(8)
                }
                .padding()
                
                //transaction list
                List{
                    ForEach(viewModel.transactions){ transaction in
                        HStack{
                            VStack(alignment: .leading){
                                Text(transaction.title)
                                Text(transaction.date, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(transaction.isExpense ? "-" : "+")IDR\(transaction.amount, specifier: "%.2f")")
                                                            .foregroundColor(transaction.isExpense ? .red : .green)
                        }
                    }
                    .onDelete{ offsets in
                        transactionToDelete = viewModel.transactions[offsets.first!].id
                            showingDeleteAlert = true
                    }
                }
                .alert("Deleted Transaction", isPresented:$showingDeleteAlert){
                    Button("Cancel", role: .cancel){}
                    Button("Delete", role: .destructive){
                        if let id = transactionToDelete{
                            viewModel.deleteTransaction(withId: id)
                        }
                    }
                }message:{
                    Text("Are you sure you want to delete this transaction?")
                }
            }
            .navigationTitle("Finance Tracker")
        }
    }
    
    private func deleteTransaction(at offsets: IndexSet) {
        offsets.forEach{ index in
            let transactionId = viewModel.transactions[index].id
            viewModel.deleteTransaction(withId: transactionId)
        }
    }
    
    private func dismissKeyboard() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                          to: nil,
                                          from: nil,
                                          for: nil)
        }
}

#Preview {
    ContentView()
}
