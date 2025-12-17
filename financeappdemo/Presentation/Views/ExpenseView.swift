//
//  ExpenseView.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//
import SwiftUI

struct ExpenseView: View {
    @ObservedObject var viewModel: ExpenseViewModel
    @State private var showAdd = false
    @State private var amountString = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading) {
                        Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                            .font(.headline)
                        Text(item.date, style: .date)
                            .font(.caption)
                        if let note = item.note { Text(note).font(.subheadline) }
                    }
                }
                .onDelete { idxs in
                    for i in idxs {
                        viewModel.delete(id: viewModel.items[i].id)
                    }
                }
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showAdd.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                NavigationView {
                    Form {
                        TextField("Amount", text: $amountString)
                            .keyboardType(.decimalPad)
                    }
                    .navigationTitle("Add Expense")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                if let amt = Double(amountString.trimmingCharacters(in: .whitespaces)) {
                                    viewModel.add(amount: amt, note: nil)
                                    showAdd = false
                                    amountString = ""
                                }
                            }
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAdd = false }
                        }
                    }
                }
            }
            .onAppear { viewModel.fetch() }
        }
    }
}
