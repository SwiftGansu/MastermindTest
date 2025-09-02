//
//  MastermindApp.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import SwiftUI

@main
struct MastermindApp: App {
   
    var body: some Scene {
    
        WindowGroup {
        
            MMMastermindView(viewModel: MMMastermindViewModel())
                .preferredColorScheme(.light)
        }
    }
}
