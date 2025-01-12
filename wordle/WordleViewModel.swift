//
//  WordleViewModel.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

class WordleViewModel: ObservableObject {
    @Published private var model: WordleModel
    
    init() {
        self.model = WordleModel()
    }
    
    // MARK: - Public Properties
    var currentGuess: String {
        get { model.currentGuess }
        set { model.currentGuess = newValue.lowercased() }
    }
    
    var attempt: Int { model.attempt }
    var guesses: [String] { model.guesses }
    var flipAnimationStates: [Bool] {
        get { model.animationStates.flipCards }
        set { model.animationStates.flipCards = newValue }
    }
    
    var correctGuessAnimationStates: [Bool] {
        get { model.animationStates.correctGuessRows }
        set { model.animationStates.correctGuessRows = newValue }
    }
    
    var showAlert: Bool {
        get { model.gameState != .playing }
        set { 
            if !newValue { 
                model.gameState = .playing 
            }
        }
    }
    
    var alertTitle: String { model.gameState.alertTitle }
    var alertMessage: String { model.gameState.alertMessage }
    
    var shouldShowConfirmButtons: Bool {
        if case .confirmingReset = model.gameState { return true }
        return false
    }
    
    // MARK: - Public Methods
    func letter(at row: Int, column: Int) -> String {
        guard row < model.attempt else { return "" }
        let guessArray = Array(model.guesses[row])
        return column < guessArray.count ? String(guessArray[column]) : ""
    }
    
    func color(at row: Int, column: Int) -> Color {
        guard row < model.attempt else { return .gray }
        let guessArray = Array(model.guesses[row])
        let secretArray = Array(model.secretWord)
        guard column < guessArray.count else { return .gray }
        
        if guessArray[column] == secretArray[column] {
            return .green
        } else if model.secretWord.contains(guessArray[column]) {
            return .yellow
        }
        return .gray
    }
    
    func submitGuess() {
        guard model.currentGuess.count == 5 else { return }
        
        model.guesses[model.attempt] = model.currentGuess
        animateGuess()
        
        model.attempt += 1
        
        if model.currentGuess == model.secretWord {
            handleWin()
        } else if model.attempt == 6 {
            handleLoss()
        }
        
        model.currentGuess = ""
    }
    
    func initiateGameReset() {
        model.gameState = .confirmingReset
    }
    
    func confirmGameReset() {
        resetGame()
    }
    
    func setAnimationState(at index: Int, to value: Bool) {
        model.animationStates.flipCards[index] = value
    }
    
    // MARK: - Private Methods
    private func resetGame() {
        model = WordleModel()
    }
    
    private func animateGuess() {
        let currentAttempt = model.attempt
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                self.setAnimationState(at: currentAttempt * 5 + i, to: true)
            }
        }
    }
    
    private func handleWin() {
        let currentAttempt = model.attempt
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.model.animationStates.correctGuessRows[currentAttempt-1] = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            self.model.gameState = .won(self.model.secretWord)
        }
    }
    
    private func handleLoss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.model.gameState = .lost(self.model.secretWord)
        }
    }
}