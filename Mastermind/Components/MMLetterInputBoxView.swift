//
//  MMLetterInputBoxView.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import SwiftUI

struct MMLetterInputBoxView: View {
    
    @Binding var text: String
   
    let backgroundColor: Color
    let onTextChange: (String) -> Void
    let index: Int
    
    var body: some View {
        
        TextField("?", text: $text)
            .keyboardType(.alphabet)
            .font(.system(size: 30, weight: .bold))
            .multilineTextAlignment(.center)
            .frame(width: 60, height: 60)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay{
                
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            }
            .onChange(of: text) { oldValue, newValue in
                // Keep only letters and limit to 1 character
                let filtered = newValue.filter { $0.isLetter }.uppercased()
                let limited = String(filtered.prefix(1))
                
                if text != limited {
                    text = limited
                }
                
                onTextChange(limited)
            }
    }
}

#Preview {
    
    VStack(spacing: 20) {
        
        MMLetterInputBoxView(
            text: .constant("A"),
            backgroundColor: .green,
            onTextChange: { _ in },
            index: 0
        )
        
        MMLetterInputBoxView(
            text: .constant("B"), 
            backgroundColor: .orange,
            onTextChange: { _ in },
            index: 1
        )
        
        MMLetterInputBoxView(
            text: .constant(""),
            backgroundColor: .gray,
            onTextChange: { _ in },
            index: 2
        )
    }
    .padding()
}
