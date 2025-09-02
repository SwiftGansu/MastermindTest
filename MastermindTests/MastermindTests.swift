//
//  MastermindTests.swift
//  MastermindTests
//
//  Created by Gandi Pirkov on 2.09.25.
//

import XCTest
@testable import Mastermind

// Mock word generator for testing
struct MMMockWordGenerator: MMWordGeneratorProtocol {
    let fixedWord: String
    
    func generateRandomWord() -> String {
        return fixedWord
    }
}

final class MastermindTests: XCTestCase {
    
    // MARK: - MMMastermindGame Tests
    
    func testGameInitialization() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        XCTAssertEqual(game.secretWord, "ABCD")
        XCTAssertFalse(game.gameState.hasCheckedGuess)
        XCTAssertFalse(game.gameState.isGameWon)
        XCTAssertEqual(game.gameState.currentGuess.count, 4)
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.isEmpty })
    }
    
    func testUpdateLetter() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Test valid letter update
        game.updateLetter(at: 0, with: "A")
        XCTAssertEqual(game.gameState.currentGuess[0].character, "A")
        XCTAssertEqual(game.gameState.currentGuess[0].state, MMLetterState.empty)
        
        // Test lowercase conversion
        game.updateLetter(at: 1, with: "b")
        XCTAssertEqual(game.gameState.currentGuess[1].character, "B")
        
        // Test invalid position
        game.updateLetter(at: 10, with: "C")
        // Should not crash or change anything
        
        // Test nil character
        game.updateLetter(at: 0, with: nil)
        XCTAssertNil(game.gameState.currentGuess[0].character)
    }
    
    func testCanCheck() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Initially cannot check (empty guess)
        XCTAssertFalse(game.gameState.canCheck)
        
        // Fill all positions
        for i in 0..<4 {
            game.updateLetter(at: i, with: Character(UnicodeScalar(65 + i)!))
        }
        
        // Now should be able to check
        XCTAssertTrue(game.gameState.canCheck)
        
        // After checking, cannot check again
        game.checkGuess()
        XCTAssertFalse(game.gameState.canCheck)
    }
    
    func testCorrectGuess() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Set correct guess
        game.updateLetter(at: 0, with: "A")
        game.updateLetter(at: 1, with: "B")
        game.updateLetter(at: 2, with: "C")
        game.updateLetter(at: 3, with: "D")
        
        game.checkGuess()
        
        // All should be correct
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.state == MMLetterState.correct })
        XCTAssertTrue(game.gameState.isGameWon)
        XCTAssertTrue(game.gameState.hasCheckedGuess)
    }
    
    func testWrongPositionGuess() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Set guess with all letters in wrong positions
        game.updateLetter(at: 0, with: "D")
        game.updateLetter(at: 1, with: "C")
        game.updateLetter(at: 2, with: "B")
        game.updateLetter(at: 3, with: "A")
        
        game.checkGuess()
        
        // All should be wrong position
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.state == MMLetterState.wrongPosition })
        XCTAssertFalse(game.gameState.isGameWon)
    }
    
    func testIncorrectGuess() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Set guess with letters not in secret
        game.updateLetter(at: 0, with: "X")
        game.updateLetter(at: 1, with: "Y")
        game.updateLetter(at: 2, with: "Z")
        game.updateLetter(at: 3, with: "W")
        
        game.checkGuess()
        
        // All should be incorrect
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.state == MMLetterState.incorrect })
        XCTAssertFalse(game.gameState.isGameWon)
    }
    
    func testMixedGuess() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Mixed guess: correct, wrong position, incorrect, correct
        game.updateLetter(at: 0, with: "A") // Correct
        game.updateLetter(at: 1, with: "C") // Wrong position
        game.updateLetter(at: 2, with: "X") // Incorrect
        game.updateLetter(at: 3, with: "D") // Correct
        
        game.checkGuess()
        
        XCTAssertEqual(game.gameState.currentGuess[0].state, MMLetterState.correct)
        XCTAssertEqual(game.gameState.currentGuess[1].state, MMLetterState.wrongPosition)
        XCTAssertEqual(game.gameState.currentGuess[2].state, MMLetterState.incorrect)
        XCTAssertEqual(game.gameState.currentGuess[3].state, MMLetterState.correct)
        XCTAssertFalse(game.gameState.isGameWon)
    }
    
    func testDuplicateLettersInGuess() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "AABC")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Guess with duplicate A's where secret has two A's
        game.updateLetter(at: 0, with: "A") // Correct
        game.updateLetter(at: 1, with: "A") // Correct
        game.updateLetter(at: 2, with: "B") // Correct
        game.updateLetter(at: 3, with: "C") // Correct
        
        game.checkGuess()
        
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.state == MMLetterState.correct })
        XCTAssertTrue(game.gameState.isGameWon)
    }
    
    func testDuplicateLettersComplexCase() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "AABC")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Guess with three A's where secret has only two
        game.updateLetter(at: 0, with: "A") // Correct
        game.updateLetter(at: 1, with: "A") // Correct  
        game.updateLetter(at: 2, with: "A") // Should be incorrect (no more A's available)
        game.updateLetter(at: 3, with: "D") // Incorrect
        
        game.checkGuess()
        
        XCTAssertEqual(game.gameState.currentGuess[0].state, MMLetterState.correct)
        XCTAssertEqual(game.gameState.currentGuess[1].state, MMLetterState.correct)
        XCTAssertEqual(game.gameState.currentGuess[2].state, MMLetterState.incorrect)
        XCTAssertEqual(game.gameState.currentGuess[3].state, MMLetterState.incorrect)
        XCTAssertFalse(game.gameState.isGameWon)
    }
    
    func testNewGame() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        // Play a game
        game.updateLetter(at: 0, with: "A")
        game.updateLetter(at: 1, with: "B")
        game.updateLetter(at: 2, with: "C")
        game.updateLetter(at: 3, with: "D")
        game.checkGuess()
        
        XCTAssertTrue(game.gameState.hasCheckedGuess)
        XCTAssertTrue(game.gameState.isGameWon)
        
        // Start new game
        game.newGame()
        
        XCTAssertFalse(game.gameState.hasCheckedGuess)
        XCTAssertFalse(game.gameState.isGameWon)
        XCTAssertTrue(game.gameState.currentGuess.allSatisfy { $0.isEmpty })
        XCTAssertEqual(game.secretWord, "ABCD") // Same mock generator
    }
    
    // MARK: - MMGameState Tests
    
    func testGameStateInitialization() {
        let gameState = MMGameState(secretWord: "test")
        
        XCTAssertEqual(gameState.secretWord, "TEST")
        XCTAssertEqual(gameState.currentGuess.count, 4)
        XCTAssertFalse(gameState.hasCheckedGuess)
        XCTAssertFalse(gameState.isGameWon)
        XCTAssertTrue(gameState.currentGuess.allSatisfy { $0.isEmpty })
    }
    
    func testCurrentGuessString() {
        var gameState = MMGameState(secretWord: "TEST")
        
        gameState.currentGuess[0].character = "A"
        gameState.currentGuess[1].character = "B"
        gameState.currentGuess[2].character = "C"
        gameState.currentGuess[3].character = "D"
        
        XCTAssertEqual(gameState.currentGuessString, "ABCD")
    }
    
    // MARK: - MMGameLetter Tests
    
    func testGameLetterInitialization() {
        let letter = MMGameLetter()
        
        XCTAssertNil(letter.character)
        XCTAssertEqual(letter.state, MMLetterState.empty)
        XCTAssertTrue(letter.isEmpty)
        XCTAssertEqual(letter.displayCharacter, "")
    }
    
    func testGameLetterWithCharacter() {
        let letter = MMGameLetter(character: "a", state: MMLetterState.correct)
        
        XCTAssertEqual(letter.character, "a")
        XCTAssertEqual(letter.state, MMLetterState.correct)
        XCTAssertFalse(letter.isEmpty)
        XCTAssertEqual(letter.displayCharacter, "A")
    }
    
    // MARK: - Performance Tests
    
    func testCheckGuessPerformance() {
        let mockGenerator = MMMockWordGenerator(fixedWord: "ABCD")
        let game = MMMastermindGame(wordGenerator: mockGenerator)
        
        game.updateLetter(at: 0, with: "X")
        game.updateLetter(at: 1, with: "Y")
        game.updateLetter(at: 2, with: "Z")
        game.updateLetter(at: 3, with: "W")
        
        self.measure {
            game.checkGuess()
            game.newGame()
            game.updateLetter(at: 0, with: "X")
            game.updateLetter(at: 1, with: "Y")
            game.updateLetter(at: 2, with: "Z")
            game.updateLetter(at: 3, with: "W")
        }
    }
}
