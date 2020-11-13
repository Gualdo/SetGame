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
        return model.deck
    }
    
    // MARK: - Intent(s)
    
    func choose(card: SetGameModel.Card) {
        model.choose(card: card)
    }
    
    // MARK: - Custom Functions
    
    private static func createSetGame() -> SetGameModel {
        var deck = [SetGameModel.Card]()
        let colors: [Color] = [.green, .blue, .red]
        let numberOfSimbols: [Int] = [1, 2, 3]
        let shadings: [Double] = [0, 0.2, 1]
        return SetGameModel {
            SetGameModel.Symbol.allCases.forEach { symbol in
                for numberOfSimbols in numberOfSimbols {
                    for color in colors {
                        for shading in shadings {
                            deck.append(
                                SetGameModel.Card(
                                    id: UUID(),
                                    symbol: symbol,
                                    numberOfSimbols: numberOfSimbols,
                                    color: color,
                                    shading: shading
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
