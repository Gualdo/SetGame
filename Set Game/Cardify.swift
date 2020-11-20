//
//  Cardify.swift
//  Memorize
//
//  Created by De La Cruz, Eduardo on 10/11/2020.
//

import SwiftUI

struct Cardify {
    
    // MARK: - Drawing Constants
    
    private let cornerRadius: CGFloat = 10
    private let edgeLineWidth: CGFloat = 3
    private let shadowRadius: CGFloat = 10
}

// MARK: - AnimatableModifier protocol implementation

extension Cardify: AnimatableModifier {
    
    func body(content: Content) -> some View {
        ZStack {
            Group {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.white)
                    .shadow(radius: shadowRadius)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: edgeLineWidth)
                content
            }
        }
    }
}

// MARK: - View extension to call .cardify

extension View {
    
    func cardify() -> some View {
        self.modifier(Cardify())
    }
}
