//
//  WordleViewModel.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

class WordleViewModel: ObservableObject {
    @Published private var model = WordleModel()
    @Published var correctGuessAnimationState: [Bool] = Array(repeating: false, count: 6)
    @Published var animationState: [Bool] = Array(repeating: false, count: 30)
    @Published var showNewGameModal: Bool = false

    // Accessors for model properties
    var secretWord: String {
        model.secretWord
    }
    var guesses: [String] {
        model.guesses
    }
    var currentGuess: String {
        get { model.currentGuess }
        set { model.currentGuess = newValue }
    }
    var attempt: Int {
        model.attempt
    }
    var showAlert: Bool {
        get { model.showAlert }
        set { model.showAlert = newValue }
    }
    var alertMessage: String {
        get { model.alertMessage }
        set { model.alertMessage = newValue }
    }

    // Get the letter at a specific index
    func letter(at index: Int, letterIndex: Int) -> String {
        guard index < model.attempt else { return "" }
        let guessArray = Array(model.guesses[index])
        return letterIndex < guessArray.count ? String(guessArray[letterIndex]) : ""
    }

    // Get the color for a specific letter
    func color(at index: Int, letterIndex: Int) -> Color {
        guard index < model.attempt else { return Color.gray }
        let guessArray = Array(model.guesses[index])
        let secretArray = Array(model.secretWord)
        guard letterIndex < guessArray.count else { return Color.gray }

        if guessArray[letterIndex] == secretArray[letterIndex] {
            return Color.green
        } else if model.secretWord.contains(guessArray[letterIndex]) {
            return Color.yellow
        } else {
            return Color.gray
        }
    }

    // Submit the current guess
    func submitGuess() {
        guard model.currentGuess.count == 5 else { return }

        model.guesses[model.attempt] = model.currentGuess.lowercased()
        let currentAttempt = model.attempt
        for i in 0..<5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                self.setAnimationState(at: currentAttempt * 5 + i, to: true)
            }
        }
        if model.currentGuess.lowercased() == model.secretWord {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.correctGuessAnimationState[currentAttempt] = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                self.model.alertMessage = "Brawo! Zgadłeś słowo: \(self.model.secretWord)."
                self.model.showAlert = true
            }
        } else if model.attempt == 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.model.alertMessage = "Niestety, przegrałeś. Sekretne słowo to: \(self.model.secretWord)."
                self.model.showAlert = true
            }
        }

        model.currentGuess = ""
        model.attempt += 1
    }

    // Reset the game
    func resetGame() {
        model = WordleModel()
        correctGuessAnimationState = Array(repeating: false, count: 6)
    }

    // Set the animation state for a specific index
    func setAnimationState(at index: Int, to value: Bool) {
        animationState[index] = value
    }

    // Start a new game
    func startNewGame() {
        resetGame()
        showNewGameModal = false
    }
}
