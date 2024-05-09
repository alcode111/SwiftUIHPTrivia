//
//  SwiftUIHPTriviaApp.swift
//  SwiftUIHPTrivia
//
//  Created by Ismaïl on 05/05/2024.
//

import SwiftUI

@main
struct SwiftUIHPTriviaApp: App {
    
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
