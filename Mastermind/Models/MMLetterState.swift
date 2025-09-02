//
//  MMLetterState.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation

/// Represents the state of a letter in the mastermind game
enum MMLetterState: Equatable, CaseIterable {
    
    case empty
    case correct        // Green - letter in correct position
    case wrongPosition  // Orange - letter in secret but wrong position
    case incorrect      // Red - letter not in secret
    
    var debugDescription: String {
        
        switch self {
        case .empty:
           
            return "empty"
        
        case .correct:
            
            return "correct"
        
        case .wrongPosition:
           
            return "wrongPosition"
        
        case .incorrect:
            
            return "incorrect"
        }
    }
}
