//
//  MMLetterInputBoxViewModel.swift
//  Mastermind
//
//  Created by Gandi Pirkov on 2.09.25.
//

import Foundation
import SwiftUI

final class MMLetterInputBoxViewModel: ObservableObject, Identifiable {
    
    let id = UUID()
    
    @Published var text: String
    @Published var backgroundColor: Color
    @Published var isDisabled: Bool
    
    let onTextChange: (String) -> Void
    
    init(text: String,
         backgroundColor: Color,
         isDisabled: Bool,
         onTextChange: @escaping (String) -> Void) {
        
        self.text = text
        self.backgroundColor = backgroundColor
        self.isDisabled = isDisabled
        self.onTextChange = onTextChange
    }
    
    func update(text: String, backgroundColor: Color, isDisabled: Bool) {
      
        self.text = text
        self.backgroundColor = backgroundColor
        self.isDisabled = isDisabled
    }
}
