//
//  MMMastermindLink.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import SwiftUI

enum MMMastermindLink: Hashable, Identifiable {
    
    case newGame
    case gameInstructions
    case gameSettings
    case gameHistory
    
    var id: String {
        
        String(describing: self)
    }
    
    static func == (lhs: MMMastermindLink, rhs: MMMastermindLink) -> Bool {
        
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
       
        hasher.combine(id)
    }
}
