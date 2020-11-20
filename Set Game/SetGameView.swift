//
//  SetGameView.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

struct SetGameView: View {
    
    @ObservedObject var viewModel: SetGameViewModel
    
    @State var isMatch: Bool?
    
    var body: some View {
        NavigationView {
            VStack {
                Grid(viewModel.cards) { card in
                    CardView(card: card)
                        .padding(5)
                        .offset(card.isDealt && !card.isMatched ? CGSize(width: 0.0, height: 0.0) : card.randomPosition)
                        .onTapGesture {
                            viewModel.choose(card: card)
                            withAnimation(.linear(duration: 1.11)) {
                                isMatch = viewModel.checkMatch()
                            }
                            if let isMatch = isMatch, !isMatch { viewModel.deselectCards() }
                            withAnimation(.linear(duration: 1.12)) {
                                viewModel.clearMatchedCards()
                            }
                        }
                        .onAppear(perform: {
                            // This if make the animation works only after the first time preventing to animate all the navigationView
                            if card.isDealt {
                                withAnimation(.linear(duration: 1.13)) {
                                    viewModel.setDealt()
                                }
                            } else {
                                viewModel.setDealt()
                            }
                        })
                        .animation(.spring(), value: card.isDealt)
                }
                .padding()
                
                Button("No match, give me more cards") {
                    
                }
                .foregroundColor(.white)
                .padding(15)
                .background(Color.green)
                .cornerRadius(30)
            }
            .font(.title3)
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarItems(trailing: Button("New Game", action: {
                viewModel.createNewGame()
            }).foregroundColor(.green))
        }
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
