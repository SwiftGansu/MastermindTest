//
//  MMGameState.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation

/// Represents the overall state of the mastermind game
struct MMGameState: Equatable {
   
    var currentGuess: [MMGameLetter]
    var hasCheckedGuess: Bool
    var isGameWon: Bool
    var secretWord: String
    
    init(secretWord: String) {
       
        self.secretWord = secretWord.uppercased()
        self.currentGuess = Array(0..<4).map { _ in MMGameLetter() }
        self.hasCheckedGuess = false
        self.isGameWon = false
    }
    
    var canCheck: Bool {
       
        currentGuess.allSatisfy { !$0.isEmpty } && !hasCheckedGuess
    }
    
    var currentGuessString: String {
       
        currentGuess.map { $0.displayCharacter }.joined()
    }
    
    var isComplete: Bool {
        
        currentGuess.allSatisfy { !$0.isEmpty }
    }
}
