//
//  Constants.swift
//  SwiftUIHPTrivia
//
//  Created by Ismaïl on 05/05/2024.
//

import Foundation
import SwiftUI

enum Constants {
    static let hpFont = "PartyLetPlain"
}

struct infoBackgroundImage: View {
    var body: some View {
        Image("parchment")
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button {
    func doneButton() -> some View {
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .foregroundStyle(.white)
    }
}
