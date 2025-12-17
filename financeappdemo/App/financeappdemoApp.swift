//
//  financeappdemoApp.swift
//  financeappdemo
//
//  Created by Nazmin Parween on 01/12/25.
//

import SwiftUI

@main
struct FinanceApp: App {
    
    private let persistence = PersistenceController1.shared
    
    private let diContainer: AppDIContainer
    
    init() {
        diContainer = AppDIContainer(
            container: persistence.container
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(diContainer)
        }
    }
}
