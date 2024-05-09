//
//  Store.swift
//  SwiftUIHPTrivia
//
//  Created by admin on 09/05/2024.
//

import Foundation
import StoreKit

enum BookStatus {
    case active
    case inactive
    case locked
}

@MainActor
class Store: ObservableObject {
    @Published var books: [BookStatus] =
    [.active, .active, .inactive, .locked, .locked, .locked, .locked]
    @Published var products: [Product] = []
    
    private var productsID = ["hp4", "hp5", "hp6", "hp7"]
    
    func loadProducts() async {
        do {
            products = try await Product.products(for: productsID)
        } catch {
            print("Couldn't fetch those products: \(error)")
        }
    }
}
