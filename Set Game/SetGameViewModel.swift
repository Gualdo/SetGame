//
//  SetGameViewModel.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

class SetGameViewModel: ObservableObject {
    
    @Published private var model: SetGameModel = SetGameViewModel.createSetGame()
    
    // MARK: - Access to the Model
    
    var cards: [SetGameModel.Card] {
        return model.tableCards
    }
    
    // MARK: - Intent(s)
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    func checkMatch() {
        model.checkMatch()
    }
    
    func clearMatchedCards() {
        model.clearMatchedCards()
    }
    
    func setDealt() {
        model.setDealt()
    }
    
    // MARK: - Custom Functions
    
    private static func createSetGame() -> SetGameModel {
        var deck = [SetGameModel.Card]()
        let colors: [Color] = [.green, .blue, .red]
        let numberOfSimbols: [Int] = [1, 2, 3]
        let shadings: [Double] = [0, 0.2, 1]
        
        var randomNumber: CGFloat {
            (CGFloat.random(in: 500...1000) * CGFloat([1,-1].randomElement()!))
        }
        
        return SetGameModel {
            SetGameModel.Symbol.allCases.forEach { symbol in
                for numberOfSimbols in numberOfSimbols {
                    for color in colors {
                        for shading in shadings {
                            let randomSize = CGSize(width: randomNumber, height: randomNumber)
                            deck.append(
                                SetGameModel.Card(
                                    id: UUID(),
                                    symbol: symbol,
                                    numberOfSimbols: numberOfSimbols,
                                    color: color,
                                    shading: shading,
                                    randomPosition: randomSize
                                )
                            )
                        }
                    }
                }
            }
            return deck
        }
    }
}
