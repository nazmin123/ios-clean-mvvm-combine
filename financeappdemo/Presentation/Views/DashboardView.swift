//
//  DashboardView.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//
import SwiftUI
struct DashboardView: View {
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Total Income: \(viewModel.totalIncome, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Text("Total Expense: \(viewModel.totalExpense, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Text("Balance: \(viewModel.balance, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))")
                Spacer()
            }
            .padding()
            .navigationTitle("Dashboard")
            .toolbar {
                Button("Refresh") {
                    viewModel.refresh()
                }
            }
        }
        .onAppear { viewModel.refresh() }
    }
}
