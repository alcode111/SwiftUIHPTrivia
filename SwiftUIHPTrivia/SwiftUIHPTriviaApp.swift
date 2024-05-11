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
    @StateObject private var game = Game()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                    game.loadScores()
                    store.loadStatus()
                }
        }
    }
}
