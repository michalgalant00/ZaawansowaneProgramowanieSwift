//
//  WordleModel.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import Foundation

struct WordleModel {
    let possibleWords = ["apple", "grape", "melon", "peach", "berry"]
    var secretWord: String = possibleWords.randomElement()!
    var guesses: [String] = Array(repeating: "", count: 6)
    var currentGuess: String = ""
    var attempt: Int = 0
    var gameState: GameState = .playing
    var animationStates: AnimationStates = AnimationStates()
    
    struct AnimationStates {
        var flipCards: [Bool]
        var correctGuessRows: [Bool]
        
        init() {
            flipCards = Array(repeating: false, count: 30)
            correctGuessRows = Array(repeating: false, count: 6)
        }
    }
    
    enum GameState {
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
}
