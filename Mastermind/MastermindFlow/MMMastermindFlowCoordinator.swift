//
//  MMMastermindFlowCoordinator.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import SwiftUI

open class MMMastermindFlowState: ObservableObject {
    
    @Published var navigationPath: NavigationPath = NavigationPath()
    @Published var presentedItem: MMMastermindLink?
    @Published var coverItem: MMMastermindLink?
}

struct MMMastermindFlowCoordinator<Content: View>: View {
    
    @StateObject var state: MMMastermindFlowState
    let content: () -> Content
    
    var body: some View {
        
        NavigationStack(path: $state.navigationPath) {
            
            ZStack {
                
                content()
                    .sheet(item: $state.presentedItem, content: sheetContent)
                    .fullScreenCover(item: $state.coverItem, content: coverContent)
            }
            .navigationDestination(for: MMMastermindLink.self, destination: linkDestination)
        }
    }
    
    @ViewBuilder
    private func linkDestination(link: MMMastermindLink) -> some View {
        
        switch link {
            
        case .gameSettings:
            gameSettingsView()
            
        case .gameHistory:
            gameHistoryView()
            
        case .gameInstructions:
            gameInstructionsView()
            
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private func coverContent(item: MMMastermindLink) -> some View {
        EmptyView()
    }
    
    @ViewBuilder
    private func sheetContent(item: MMMastermindLink) -> some View {
        
        switch item {
            
        case .newGame:
          
            newGameView()
            
        default:
            
            EmptyView()
        }
    }
    
    private func gameSettingsView() -> some View {
        
        Text("Game Settings")
            .font(.title)
            .navigationTitle("Settings")
    }
    
    private func gameHistoryView() -> some View {
        
        Text("Game History")
            .font(.title)
            .navigationTitle("History")
    }
    
    private func gameInstructionsView() -> some View {
        
        VStack(spacing: 16) {
            Text("How to Play Mastermind")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                
                HStack {
                    Circle().fill(.green).frame(width: 16, height: 16)
                    Text("Green: Correct letter in correct position")
                }
                
                HStack {
                    Circle().fill(.orange).frame(width: 16, height: 16)
                    Text("Orange: Correct letter in wrong position")
                }
                
                HStack {
                    Circle().fill(.red).frame(width: 16, height: 16)
                    Text("Red: Letter not in the secret word")
                }
            }
            .padding()
            
            Text("Try to guess the 4-letter secret word!")
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .padding()
        .navigationTitle("Instructions")
    }
    
    private func newGameView() -> some View {
        
        VStack {
           
            Text("Start New Game")
                .font(.title)
                .padding()
            
            Text("This will reset your current progress.")
                .foregroundColor(.secondary)
            
            Button("Start New Game") {
                // This would trigger new game logic
                state.presentedItem = nil
            }
            .buttonStyle(.borderless)
            .padding()
        }
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}
