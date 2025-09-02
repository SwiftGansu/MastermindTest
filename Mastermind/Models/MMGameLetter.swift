//
//  MMGameLetter.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation

/// Represents a single letter in the game with its state
struct MMGameLetter: Identifiable, Equatable {
    
    let id = UUID()
    var character: Character?
    var state: MMLetterState
    
    init(character: Character? = nil, state: MMLetterState = .empty) {
        self.character = character
        self.state = state
    }
    
    var isEmpty: Bool {
        character == nil
    }
    
    var displayCharacter: String {
       
        if let character = character {
        
            return String(character).uppercased()
        }
        
        return ""
    }
}
