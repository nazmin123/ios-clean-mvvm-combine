//
//  ContentView.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var container: AppDIContainer
    
    var body: some View {
        TabView {
            let dashVM = container.makeDashboardViewModel()
            DashboardView(viewModel: dashVM)
                .tabItem { Label("Dashboard", systemImage: "chart.pie.fill") }
            
            let incVM = container.makeIncomeViewModel()
            IncomeView(viewModel: incVM)
                .tabItem { Label("Income", systemImage: "tray.and.arrow.down.fill") }
            
            let expVM = container.makeExpenseViewModel()
            ExpenseView(viewModel: expVM)
                .tabItem { Label("Expenses", systemImage: "tray.and.arrow.up.fill") }
            
            let goalVM = container.makeGoalViewModel()
            GoalView(viewModel: goalVM)
                .tabItem { Label("Goal", systemImage: "target") }
            
            let postVM = container.makePostListViewModel()
            PostListView(viewModel: postVM)
                .tabItem { Label("Posts", systemImage: "doc.text.fill") }
        }
    }
}










