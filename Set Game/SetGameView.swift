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
    @State var presentHintAlert: Bool = false
    @State var presentNoMorePossibleMatchesAlert: Bool = false
    @State var presentYouWon: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                    Grid(viewModel.cards) { card in
                        CardView(card: card)
                            .padding(5)
                            .offset(card.isDealt && !card.isMatched ? CGSize(width: 0.0, height: 0.0) : card.randomPosition)
                            .onTapGesture {
                                viewModel.choose(card: card)
                                isMatch = viewModel.checkMatch()
                                if let isMatch = isMatch, !isMatch { viewModel.deselectCards() }
                                viewModel.clearMatchedCardsIfNeeded()
                                if viewModel.shouldClear {
                                    viewModel.clearMatchedCards()
                                }
                                presentYouWon = viewModel.youWon
                            }
                            .onAppear(perform: {
                                viewModel.setDealt()
                            })
                            .animation(.linear(duration: 0.75), value: card.isMatched)
                            .animation(.linear(duration: 1), value: viewModel.shouldClear)
                            .animation(.linear(duration: 0.75), value: card.isDealt)
                            .alert(isPresented: $presentHintAlert, content: {
                                Alert(title: Text("There is a match"), message: Text("Even if you haven't seen it, there is a SET, you want a hint for 2 of your points"), primaryButton: .default(Text("Yes please"), action: {
                                    viewModel.showHint()
                                }), secondaryButton: .destructive(Text("No, thanks"), action: {
                                    viewModel.notShowHint()
                                }))
                            })
                    }
                    .padding()
                
                Button("No match, give me more cards") {
                    if viewModel.noMatchMoreCards() {
                        presentHintAlert = true
                    }
                    if viewModel.noMorePossibleMatches {
                        presentNoMorePossibleMatchesAlert = true
                    }
                }
                .foregroundColor(.white)
                .padding(15)
                .background(Color.green)
                .cornerRadius(30)
                .alert(isPresented: $presentNoMorePossibleMatchesAlert, content: {
                    Alert(title: Text("There no more matches"), message: Text("Nice try!!! Better luck next time. Do you wanto to play a new game?"), primaryButton: .default(Text("Yes please"), action: {
                        viewModel.createNewGame()
                    }), secondaryButton: .destructive(Text("No, thanks")))
                })
            }
            .font(.title3)
            .navigationBarTitle(viewModel.title, displayMode: .inline)
            .navigationBarItems(leading: Text("Points: \(viewModel.points)").foregroundColor(.green), trailing: Button("New Game", action: {
                viewModel.createNewGame()
            }).foregroundColor(.green))
            
        }
        .animation(.none)
        .alert(isPresented: $presentYouWon) { () -> Alert in
            Alert(title: Text("You Won!!!"), message: Text(viewModel.points == 27 ? "Awesome!!!, you completed the SET Game with PERFECT SCORE!!!🥳🎉" : "Finally!!!, you completed the SET Game"), dismissButton: .default(Text("New Game"), action: {
                viewModel.createNewGame()
            }))
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
        .foregroundColor(card.isSelected ? .red : card.isPossibleMatch ? .orange : .gray)
    }
    
    // MARK: - Drawing Constants
    
    private let aspectRatio: CGFloat = 2.21
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SetGameView(viewModel: SetGameViewModel())
    }
}
