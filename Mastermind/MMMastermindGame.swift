//
//  MMMastermindGame.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation

/// Protocol for generating random words, making testing easier
protocol MMWordGeneratorProtocol {
    func generateRandomWord() -> String
}

/// Default implementation of MMWordGeneratorProtocol
struct MMDefaultWordGenerator: MMWordGeneratorProtocol {
    func generateRandomWord() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        return String((0..<4).map { _ in letters.randomElement()! })
    }
}

/// Main business logic for the Mastermind game following TrophyGolf patterns
final class MMMastermindGame: ObservableObject {
    
    private let wordGenerator: MMWordGeneratorProtocol
    @Published private(set) var gameState: MMGameState
    
    init(wordGenerator: MMWordGeneratorProtocol = MMDefaultWordGenerator()) {
       
        self.wordGenerator = wordGenerator
        self.gameState = MMGameState(secretWord: wordGenerator.generateRandomWord())
    }
    
    /// Update a letter at specific position
    func updateLetter(at position: Int, with character: Character?) {
        
        guard position >= 0 && position < gameState.currentGuess.count else { return }
        
        // Create a new gameState to trigger @Published
        var newGameState = gameState
        
        if let char = character, char.isLetter {
            newGameState.currentGuess[position].character = Character(char.uppercased())
        } else {
            newGameState.currentGuess[position].character = nil
        }
        
        // Reset state to empty and allow checking again
        newGameState.currentGuess[position].state = .empty
        newGameState.hasCheckedGuess = false  // Reset to allow checking again
        
        // Assign the new state to trigger @Published
        gameState = newGameState
    }
    
    /// Check the current guess against the secret word
    func checkGuess() {
        
        guard gameState.canCheck else { return }
        
        let guess = gameState.currentGuessString
        let secret = gameState.secretWord
        
        // Create a new gameState to trigger @Published properly
        var newGameState = gameState
        
        // Track which secret letters have been used for wrong position matches
        var secretUsed = Array(repeating: false, count: secret.count)
        var guessProcessed = Array(repeating: false, count: guess.count)
        
        // First pass: Mark correct positions (green)
        for i in 0..<guess.count {
            
            let guessChar = guess[guess.index(guess.startIndex, offsetBy: i)]
            let secretChar = secret[secret.index(secret.startIndex, offsetBy: i)]
            
            if guessChar == secretChar {
                newGameState.currentGuess[i].state = .correct
                secretUsed[i] = true
                guessProcessed[i] = true
            }
        }
        
        // Second pass: Mark wrong positions (orange) and incorrect (red)
        for i in 0..<guess.count {
            
            if guessProcessed[i] { continue }
            
            let guessChar = guess[guess.index(guess.startIndex, offsetBy: i)]
            var foundWrongPosition = false
            
            // Look for this character in other positions of secret
            for j in 0..<secret.count {
                
                if secretUsed[j] { continue }
                
                let secretChar = secret[secret.index(secret.startIndex, offsetBy: j)]
                
                if guessChar == secretChar {
                
                    newGameState.currentGuess[i].state = .wrongPosition
                    secretUsed[j] = true
                    foundWrongPosition = true
                    
                    break
                }
            }
            
            if !foundWrongPosition {
                
                newGameState.currentGuess[i].state = .incorrect
            }
        }
        
        newGameState.hasCheckedGuess = true
        newGameState.isGameWon = newGameState.currentGuess.allSatisfy { $0.state == .correct }
        
        // Assign the new state to trigger @Published
        gameState = newGameState
    }
    
    /// Start a new game
    func newGame() {
       
        gameState = MMGameState(secretWord: wordGenerator.generateRandomWord())
    }
    
    /// Get the secret word (for testing purposes)
    var secretWord: String {
       
        gameState.secretWord
    }
}
