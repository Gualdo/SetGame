//
//  SetGameModel.swift
//  Set Game
//
//  Created by De La Cruz, Eduardo on 11/11/2020.
//

import SwiftUI

struct SetGameModel {
    
    // MARK: - Game Objects
    
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
        var isMatched: Bool = false
        var isDealt: Bool = false
        var randomPosition: CGSize
    }
    
    // MARK: - Game Variables and Init
    
    private (set) var deck: [Card]
    private (set) var tableCards: [Card]
    private var selectedCards: [Card] = [Card]()
    
    init(cardFactory: () -> [Card]) {
        tableCards = [Card]()
        deck = cardFactory()
        deck.shuffle()
        for _ in 1...12 {
            tableCards.append(deck.removeFirst())
        }
    }
    
    // MARK: - Intent(s)
    
    mutating func choose(card: Card) {
        if let chosenIdex = tableCards.firstIndex(matching: card) {
            if !tableCards[chosenIdex].isSelected {
                tableCards[chosenIdex].isSelected = true
                selectedCards.append(tableCards[chosenIdex])
            } else {
                tableCards[chosenIdex].isSelected = false
                selectedCards = selectedCards.filter { $0.id != tableCards[chosenIdex].id }
            }
        }
    }
    
    mutating func checkMatch() -> Bool? {
        if selectedCards.count == 3 {
            if isMatch() {
                for index in 0..<3 {
                    for tableIndex in 0..<tableCards.count {
                        if tableCards[tableIndex].id == selectedCards[index].id {
                            tableCards[tableIndex].isMatched = true
                        }
                    }
                }
                selectedCards.removeAll()
                return true
            } else {
                return false            }
        }
        return nil
    }
    
    mutating func deselectCards() {
        for index in 0..<tableCards.count {
            if tableCards[index].isSelected {
                tableCards[index].isSelected = false
            }
        }
        selectedCards.removeAll()
    }
    
    mutating func clearMatchedCards() {
        tableCards = tableCards.filter {
            !$0.isMatched
        }
        if tableCards.count < 12 && deck.count != 0 {
            dealMoreCards()
        } else {
            // FIXME: - Win condition
        }
    }
    
    mutating func setDealt() {
        for index in 0..<tableCards.count {
            if !tableCards[index].isDealt {
                tableCards[index].isDealt = true
            }
        }
    }
    
    mutating func dealMoreCards() {
        for _ in 1...3 {
            tableCards.append(deck.removeFirst())
        }
    }
    
    // MARK: - Matching Logic
    
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
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardNumberOfSymbols: Int = 0
        
        for index in 0..<selectedCards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardNumberOfSymbols = selectedCards[index].numberOfSimbols
                }
                
                areAllDifferent = selectedCards[index].numberOfSimbols != numberOfSymbols
                
                if index == 2, areAllDifferent {
                    areAllDifferent = selectedCards[index].numberOfSimbols != secondCardNumberOfSymbols
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards.first?.id {
                areAllEqual = card.numberOfSimbols == numberOfSymbols
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    func symboIsMatch() -> Bool {
        
        guard let symbol = selectedCards.first?.symbol else { return false }
        
        var areAllEqual: Bool = true
        var areAllDifferent: Bool = true
        var secondCardSymbol: Symbol = .diamond
        
        for index in 0..<selectedCards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardSymbol = selectedCards[index].symbol
                }
                
                areAllDifferent = selectedCards[index].symbol != symbol
                
                if index == 2, areAllDifferent {
                    areAllDifferent = selectedCards[index].symbol != secondCardSymbol
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards.first?.id {
                areAllEqual = card.symbol == symbol
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    func colorIsMatch() -> Bool {
        
        guard let color = selectedCards.first?.color else { return false }
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardColor: Color = .black
        
        for index in 0..<selectedCards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardColor = selectedCards[index].color
                }
                
                areAllDifferent = selectedCards[index].color != color
                
                if index == 2, areAllDifferent {
                    areAllDifferent = selectedCards[index].color != secondCardColor
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards.first?.id {
                areAllEqual = card.color == color
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    func shadingIsMatch() -> Bool {
        
        guard let shading = selectedCards.first?.shading else { return false }
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardShading: Double = 0.0
        
        for index in 0..<selectedCards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardShading = selectedCards[index].shading
                }
                
                areAllDifferent = selectedCards[index].shading != shading
                
                if index == 2, areAllDifferent {
                    areAllDifferent = selectedCards[index].shading != secondCardShading
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in selectedCards {
            if card.id != selectedCards.first?.id {
                areAllEqual = card.shading == shading
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
}
