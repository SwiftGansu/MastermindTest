//
//  MMMastermindViewModel.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation
import SwiftUI
import Combine

final class MMMastermindViewModel: ObservableObject {
    
    @Published private(set) var gameState: MMGameState
    @Published var inputTexts: [String] = ["", "", "", ""]
    @Published var showingWinAlert = false
    
    private let game: MMMastermindGame
    private var cancellables = Set<AnyCancellable>()
    
    init(game: MMMastermindGame = MMMastermindGame()) {
        
        self.game = game
        self.gameState = game.gameState
        
        // Subscribe to game state changes
        game.$gameState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
               
                self?.gameState = newState
                
                if newState.isGameWon && newState.hasCheckedGuess {
                    self?.showingWinAlert = true
                }
            }
            .store(in: &cancellables)
    }
    
    /// Update letter at specific position
    func updateLetter(at position: Int, with text: String) {
       
        let character = text.isEmpty ? nil : text.uppercased().first
        game.updateLetter(at: position, with: character)
        
        // Keep the input text in sync
        if position >= 0 && position < inputTexts.count {
            inputTexts[position] = text.uppercased()
        }
    }
    
    /// Check the current guess
    func checkGuess() {
        
        game.checkGuess()
    }
    
    /// Start a new game
    func newGame() {
        
        game.newGame()
        inputTexts = ["", "", "", ""]
        showingWinAlert = false
    }
    
    /// Get background color for letter at position
    func backgroundColor(for position: Int) -> Color {
        
        guard position < gameState.currentGuess.count else { return .clear }
        
        switch gameState.currentGuess[position].state {
        case .empty:
           
            return Color(.systemGray6)
       
        case .correct:
          
            return .green
       
        case .wrongPosition:
            
            return .orange
       
        case .incorrect:
            
            return .red
        }
    }
    
    /// Check if the check button should be enabled
    var canCheck: Bool {
        
        gameState.canCheck
    }
    
    /// Check if input is disabled (after checking guess)
    var isInputDisabled: Bool {
        
        gameState.hasCheckedGuess
    }
    
    /// Get display text for win alert
    var winAlertMessage: String {
        
        "Congratulations! You guessed the word: \(gameState.secretWord)"
    }
}
