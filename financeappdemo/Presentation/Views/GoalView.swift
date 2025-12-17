//
//  GoalView.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 13/12/25.
//
import SwiftUI

struct GoalView: View {
    
    @ObservedObject var viewModel: GoalViewModel
    @State private var showAdd = false
    @State private var title = ""
    @State private var targetAmount = ""
    @State private var currentAmount = ""
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(viewModel.items) { g in
                    
                    VStack(alignment: .leading) {
                        Text(g.title)
                            .font(.headline)
                        
                        let code = Locale.current.currency?.identifier ?? "USD"
                        let percent = (g.currentAmount / g.targetAmount)
                        Text("\(Int(percent * 100))% Progress")
                            .font(.subheadline)
                        Spacer()
                        // Currency row removed since you want only progress bar
                        ProgressView(
                            value: g.currentAmount,
                            total: g.targetAmount
                        )
                        .tint(.blue)          // optional color
                        .progressViewStyle(.linear)
                    }
                    
                }
                .onDelete { idxs in
                    for i in idxs {
                        viewModel.delete(id: viewModel.items[i].id)
                    }
                }
            }
            
            .navigationTitle("Goals")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAdd = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        
        
        .sheet(isPresented: $showAdd) {
            
            NavigationView {
                Form {
                    TextField("Goal Title", text: $title)
                    TextField("Target Amount", text: $targetAmount)
                        .keyboardType(.numberPad)
                    TextField("Current Amount", text: $currentAmount)
                        .keyboardType(.numberPad)
                }
                .navigationTitle("Add Goal")
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            
                            if let targetAmt = Double(targetAmount),
                               let currentAmt = Double(currentAmount) {
                                
                                viewModel.addGoal(
                                    title: title,
                                    target: targetAmt,
                                    current: currentAmt
                                )
                                
                                // Reset UI
                                showAdd = false
                                title = ""
                                targetAmount = ""
                                currentAmount = ""
                                
                            } else {
                                print("Invalid numeric input")
                            }
                            
                        }
                    }
                    
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showAdd = false
                        }
                    }
                }
            }
        }
        
        // This must be OUTSIDE NAVIGATIONVIEW and OUTSIDE sheet
        .onAppear {
            viewModel.fetch()
        }
    }
}
