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
        var isPossibleMatch: Bool = false
        var randomPosition: CGSize
    }
    
    // MARK: - Game Variables and Init
    
    private var deck: [Card]
    private (set) var tableCards: [Card]
    private var selectedCards: [Card] = [Card]()
    private var matchHintCards: [Card] = [Card]()
    private var userWantsHint: Bool = false
    private var youWon: Bool = false
    private (set) var noMorePossibleMatches: Bool = false
    private (set) var shouldClear: Bool = false
    
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
                return false
            }
        }
        return nil
    }
    
    mutating func clearMatchedCardsIfNeeded() {
        for card in tableCards {
            if card.isMatched {
                shouldClear = true
                break
            } else {
                shouldClear = false
            }
        }
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
        if tableCards.count < 12, tableCards.count != 0, deck.count != 0 {
            dealMoreCards()
        } else if tableCards.count == 0 {
            youWon = true
        }
    }
    
    mutating func setDealt() {
        for index in 0..<tableCards.count {
            if !tableCards[index].isDealt {
                tableCards[index].isDealt = true
            }
        }
    }
    
    mutating func noMatchMoreCards() -> Bool {
        for indexOne in 0..<(tableCards.count - 2) {
            for indexTwo in (indexOne + 1)..<tableCards.count {
                for indexThree in (indexTwo + 1)..<tableCards.count {
                    let possibleMatch = [tableCards[indexOne], tableCards[indexTwo], tableCards[indexThree]]
                    if isMatch(possibleMatch: possibleMatch) {
                        matchHintCards = possibleMatch
                        return true
                    }
                }
            }
        }
        
        if deck.count != 0 {
            dealMoreCards()
        } else {
            noMorePossibleMatches = true
        }
        
        return false
    }
    
    mutating func showHint() {
        for index in 0..<tableCards.count {
            tableCards[index].isSelected = false
            if matchHintCards.contains(where: { $0.id == tableCards[index].id }) {
                tableCards[index].isPossibleMatch = true
            }
        }
        selectedCards.removeAll()
        userWantsHint = true
        notShowHint()
    }
    
    mutating func notShowHint() {
        userWantsHint = false
        matchHintCards.removeAll()
    }
    
    // MARK: - Custom Funcs
    
    private mutating func dealMoreCards() {
        if deck.count != 0 {
            for _ in 1...3 {
                tableCards.append(deck.removeFirst())
            }
        }
    }
    
    // MARK: - Matching Logic
    
    private func isMatch(possibleMatch: [Card]? = nil) -> Bool {
        let possibleMatches: [Bool] = [
            numberOfSymbolsIsMatch(possibleMatch: possibleMatch),
            symboIsMatch(possibleMatch: possibleMatch),
            colorIsMatch(possibleMatch: possibleMatch),
            shadingIsMatch(possibleMatch: possibleMatch)
        ]
        for item in possibleMatches {
            if item == false {
                return item
            }
        }
        return true
    }
    
    private func numberOfSymbolsIsMatch(possibleMatch: [Card]? = nil) -> Bool {
        
        var cards: [Card] = [Card]()
        
        if let possibleMatch = possibleMatch {
            cards = possibleMatch
        } else {
            cards = selectedCards
        }
        
        guard let numberOfSymbols = cards.first?.numberOfSimbols else { return false }
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardNumberOfSymbols: Int = 0
        
        for index in 0..<cards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardNumberOfSymbols = cards[index].numberOfSimbols
                }
                
                areAllDifferent = cards[index].numberOfSimbols != numberOfSymbols
                
                if index == 2, areAllDifferent {
                    areAllDifferent = cards[index].numberOfSimbols != secondCardNumberOfSymbols
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in cards {
            if card.id != cards.first?.id {
                areAllEqual = card.numberOfSimbols == numberOfSymbols
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    private func symboIsMatch(possibleMatch: [Card]? = nil) -> Bool {
        
        var cards: [Card] = [Card]()
        
        if let possibleMatch = possibleMatch {
            cards = possibleMatch
        } else {
            cards = selectedCards
        }
        
        guard let symbol = cards.first?.symbol else { return false }
        
        var areAllEqual: Bool = true
        var areAllDifferent: Bool = true
        var secondCardSymbol: Symbol = .diamond
        
        for index in 0..<cards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardSymbol = cards[index].symbol
                }
                
                areAllDifferent = cards[index].symbol != symbol
                
                if index == 2, areAllDifferent {
                    areAllDifferent = cards[index].symbol != secondCardSymbol
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in cards {
            if card.id != cards.first?.id {
                areAllEqual = card.symbol == symbol
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    private func colorIsMatch(possibleMatch: [Card]? = nil) -> Bool {
        
        var cards: [Card] = [Card]()
        
        if let possibleMatch = possibleMatch {
            cards = possibleMatch
        } else {
            cards = selectedCards
        }
        
        guard let color = cards.first?.color else { return false }
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardColor: Color = .black
        
        for index in 0..<cards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardColor = cards[index].color
                }
                
                areAllDifferent = cards[index].color != color
                
                if index == 2, areAllDifferent {
                    areAllDifferent = cards[index].color != secondCardColor
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in cards {
            if card.id != cards.first?.id {
                areAllEqual = card.color == color
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
    
    private func shadingIsMatch(possibleMatch: [Card]? = nil) -> Bool {
        
        var cards: [Card] = [Card]()
        
        if let possibleMatch = possibleMatch {
            cards = possibleMatch
        } else {
            cards = selectedCards
        }
        
        guard let shading = cards.first?.shading else { return false }
        
        var areAllEqual = true
        var areAllDifferent = true
        var secondCardShading: Double = 0.0
        
        for index in 0..<cards.count {
            if index != 0 {
                
                if index == 1 {
                    secondCardShading = cards[index].shading
                }
                
                areAllDifferent = cards[index].shading != shading
                
                if index == 2, areAllDifferent {
                    areAllDifferent = cards[index].shading != secondCardShading
                }
                
                if !areAllDifferent {
                    break
                }
            }
        }
        
        for card in cards {
            if card.id != cards.first?.id {
                areAllEqual = card.shading == shading
                if !areAllEqual {
                    break
                }
            }
        }
        
        return areAllEqual == true || areAllDifferent == true
    }
}
