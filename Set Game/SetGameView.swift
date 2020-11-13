//
//  SetGameView.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    var cards: [SetGameModel.Card] {
        return Array(viewModel.cards[0..<viewModel.cards.count])//12])
    }
    
    var body: some View {
        VStack {
            Grid(cards) { card in
                CardView(card: card)
                    .onTapGesture {
                        viewModel.choose(card: card)
                    }
                    .padding(5)
            }
        }
        .padding()
    }
}

struct CardView: View {
    
    var card: SetGameModel.Card
    
    var body: some View {
        GeometryReader { geometry in
            body(for: geometry.size)
        }
    }
    
    // MARK: - Custom Functions
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        VStack {
            ForEach(1...card.numberOfSimbols, id: \.self) {
                let _ =  $0
                switch card.symbol {
                    case .diamond:
                        ZStack {
                            Diamond()
                                .stroke(lineWidth: 2)
                                .fill(card.color)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                            Diamond()
                                .fill(card.color)
                                .opacity(card.shading)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                        
                    case .rectangle:
                        ZStack {
                            Rectangle()
                                .stroke(lineWidth: 2)
                                .fill(card.color)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                            Rectangle()
                                .fill(card.color)
                                .opacity(card.shading)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                        
                    case .oval:
                        ZStack {
                            Capsule()
                                .stroke(lineWidth: 2)
                                .fill(card.color)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                            Capsule()
                                .fill(card.color)
                                .opacity(card.shading)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                }
            }
        }
        .padding()
        .cardify()
        .foregroundColor(card.isSelected ? .red : .gray)
    }
    
    // MARK: - Drawing Constants
    
    private let aspectRatio: CGFloat = 2.21
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(viewModel: SetGameViewModel())
    }
}
