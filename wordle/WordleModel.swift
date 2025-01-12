//
//  WordleModel.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import Foundation

struct WordleModel {
    let possibleWords = ["apple", "grape", "melon", "peach", "berry"]
    var secretWord: String
    var guesses: [String]
    var currentGuess: String
    var attempt: Int
    var gameState: GameState
    var animationStates: AnimationStates
    
    struct AnimationStates {
        var flipCards: [Bool]
        var correctGuessRows: [Bool]
        
        init() {
            flipCards = Array(repeating: false, count: 30)
            correctGuessRows = Array(repeating: false, count: 6)
        }
    }
    
    enum GameState : Comparable {
        case playing
        case won(String)
        case lost(String)
        case confirmingReset
        
        var alertTitle: String {
            switch self {
            case .won, .lost: return "Koniec gry"
            case .confirmingReset: return "Nowa gra"
            case .playing: return ""
            }
        }
        
        var alertMessage: String {
            switch self {
            case .won(let word): return "Brawo! Zgadłeś słowo: \(word)"
            case .lost(let word): return "Niestety, przegrałeś. Sekretne słowo to: \(word)"
            case .confirmingReset: return "Czy chcesz rozpocząć nową grę?"
            case .playing: return ""
            }
        }
    }

    init() {
        self.secretWord = possibleWords.randomElement()!
        self.guesses = Array(repeating: "", count: 6)
        self.currentGuess = ""
        self.attempt = 0
        self.gameState = .playing
        self.animationStates = AnimationStates()
    }
}
