//
//  WordleModel.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import Foundation

struct WordleModel {
    var secretWord: String
    var guesses: [String]
    var currentGuess: String
    var attempt: Int
    var showAlert: Bool
    var alertMessage: String
    var animationState: [Bool]

    init() {
        self.secretWord = ["apple", "grape", "melon", "peach", "berry"].randomElement()!
        self.guesses = Array(repeating: "", count: 6)
        self.currentGuess = ""
        self.attempt = 0
        self.showAlert = false
        self.alertMessage = ""
        self.animationState = Array(repeating: false, count: 30)
    }
}
