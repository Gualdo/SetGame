//
//  SetGameModel.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

struct SetGameModel {
    
    enum Symbol: CaseIterable {
        case diamond
        case rectangle
        case oval
    }

    struct Card: Identifiable {
        
        var id: UUID
        var symbol: Symbol
        var numberOfSimbols: Int
        var color: Color
        var shading: Double
        var isSelected: Bool = false
    }
    
    private (set) var deck: [Card]
    private var selectedCards: [Card] = [Card]()
    
    init(cardFactory: () -> [Card]) {
        deck = cardFactory()
//        deck.shuffle()
    }
    
    mutating func choose(card: Card) {
        if let chosenIdex = deck.firstIndex(matching: card) {
            if !deck[chosenIdex].isSelected {
                deck[chosenIdex].isSelected = true
                selectedCards.append(deck[chosenIdex])
                if selectedCards.count == 3 {
                    if isMatch() {
                        deck = deck.filter { !$0.isSelected }
                        selectedCards.removeAll()
                    } else {
                        for index in 0..<deck.count {
                            if deck[index].isSelected {
                                deck[index].isSelected = false
                            }
                        }
                        selectedCards.removeAll()
                    }
                }
            } else {
                deck[chosenIdex].isSelected = false
                selectedCards = selectedCards.filter { $0.id != deck[chosenIdex].id }
            }
        }
    }
    
    func isMatch() -> Bool {
        
        let possibleMatches: [Bool] = [
            numberOfSymbolsIsMatch(),
            symboIsMatch(),
            colorIsMatch(),
            shadingIsMatch()
        ]
        
        for item in possibleMatches {
            if item == false {
                return item
            }
        }
        
        return true
    }
    
    func numberOfSymbolsIsMatch() -> Bool {
        
        guard let numberOfSymbols = selectedCards.first?.numberOfSimbols else { return false }
        
        var isEqual = true
        var isDifferent = true
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isDifferent = card.numberOfSimbols != numberOfSymbols
                if !isDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isEqual = card.numberOfSimbols == numberOfSymbols
                if !isEqual {
                    break
                }
            }
        }
        
        return isEqual == true || isDifferent == true
    }
    
    func symboIsMatch() -> Bool {
        
        guard let symbol = selectedCards.first?.symbol else { return false }
        
        var isEqual = true
        var isDifferent = true
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isDifferent = card.symbol != symbol
                if !isDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isEqual = card.symbol == symbol
                if !isEqual {
                    break
                }
            }
        }
        
        return isEqual == true || isDifferent == true
    }
    
    func colorIsMatch() -> Bool {
        
        guard let color = selectedCards.first?.color else { return false }
        
        var isEqual = true
        var isDifferent = true
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isDifferent = card.color != color
                if !isDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isEqual = card.color == color
                if !isEqual {
                    break
                }
            }
        }
        
        return isEqual == true || isDifferent == true
    }
    
    func shadingIsMatch() -> Bool {
        
        guard let numberOfSymbols = selectedCards.first?.numberOfSimbols else { return false }
        
        var isEqual = true
        var isDifferent = true
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isDifferent = card.numberOfSimbols != numberOfSymbols
                if !isDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards[0].id {
                isEqual = card.numberOfSimbols == numberOfSymbols
                if !isEqual {
                    break
                }
            }
        }
        
        return isEqual == true || isDifferent == true
    }
}
