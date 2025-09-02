//
//  MMMastermindView.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import SwiftUI

struct MMMastermindView: View {
    
    @StateObject var viewModel: MMMastermindViewModel
    
    var body: some View {
        
        MMMastermindFlowCoordinator(state: MMMastermindFlowState()) {
            content
        }
    }
}

extension MMMastermindView {
    
    private var content: some View {
        
        ScrollView {
            
            VStack(spacing: 30) {
                
                headerView
                gameInstructionsView
                inputBoxesView
                actionButtonsView
                
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .frame(maxWidth: .infinity)
        }
        .alert("Congratulations! 🎉", isPresented: $viewModel.showingWinAlert) {
            
            Button("New Game") {
                viewModel.newGame()
            }
            
            Button("OK") { }
            
        } message: {
        
            Text(viewModel.winAlertMessage)
        }
    }
    
    private var headerView: some View {
        
        VStack(spacing: 10) {
            
            Text("🧩 Mastermind")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Guess the 4-letter code!")
                .font(.headline)
                .foregroundColor(.secondary)
        }
    }
    
    private var gameInstructionsView: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Text("How to play:")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(spacing: 8) {
               
                Circle()
                    .fill(.green)
                    .frame(width: 16, height: 16)
               
                Text("Correct letter & position")
                    .font(.caption)
            }
            
            HStack(spacing: 8) {
                
                Circle()
                    .fill(.orange)
                    .frame(width: 16, height: 16)
                
                Text("Correct letter, wrong position")
                    .font(.caption)
            }
            
            HStack(spacing: 8) {
               
                Circle()
                    .fill(.red)
                    .frame(width: 16, height: 16)
               
                Text("Letter not in code")
                    .font(.caption)
            }
        }
        .padding()
        .background {
           
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    private var inputBoxesView: some View {
        
        VStack(spacing: 20) {
            
            Text("Enter your guess:")
                .font(.headline)
                .fontWeight(.medium)
            
            HStack(spacing: 15) {
                
                ForEach(0..<4, id: \.self) { index in
                    
                    MMLetterInputBoxView(
                        text: $viewModel.inputTexts[index],
                        backgroundColor: viewModel.backgroundColor(for: index),
                        onTextChange: { newText in
                            viewModel.updateLetter(at: index, with: newText)
                        },
                        index: index
                    )
                }
            }
        }
    }
    
    private var actionButtonsView: some View {
        
        VStack(spacing: 15) {
            
            // Check button
            Button(action: {
                viewModel.checkGuess()
            }, label: {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Check Guess")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(viewModel.canCheck ? Color.blue : Color.gray)
                )
                .scaleEffect(viewModel.canCheck ? 1.0 : 0.95)
            })
            .buttonStyle(.borderless)
            .disabled(!viewModel.canCheck)
            .animation(.easeInOut(duration: 0.2), value: viewModel.canCheck)
            
            // New Game button
            Button(action: {
                viewModel.newGame()
            }, label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("New Game")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue, lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                        )
                )
            })
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MMMastermindView(viewModel: MMMastermindViewModel())
}
