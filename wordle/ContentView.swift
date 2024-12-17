//
//  ContentView.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var secretWord = ["apple", "grape", "melon", "peach", "berry"].randomElement()!
    @State private var guesses: [String] = Array(repeating: "", count: 6)
    @State private var currentGuess = ""
    @State private var attempt = 0
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var animationState: [Bool] = Array(repeating: false, count: 30) // Animacja dla każdej litery (6 prób x 5 liter)

    var body: some View {
        VStack {
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding()

            Spacer()

            // Wyświetlanie wyników zgadywania
            ForEach(0..<6, id: \.self) { index in
                HStack {
                    ForEach(0..<5, id: \.self) { letterIndex in
                        Text(letter(at: index, letterIndex: letterIndex))
                            .frame(width: 50, height: 50)
                            .background(color(at: index, letterIndex: letterIndex))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.title)
                            .scaleEffect(animationState[index * 5 + letterIndex] ? 1.1 : 1.0)
                            .animation(.spring(response: 0.4, dampingFraction: 0.6, blendDuration: 0.5), value: animationState[index * 5 + letterIndex])
                            .onAppear {
                                if index < attempt {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(letterIndex) * 0.2) {
                                        animationState[index * 5 + letterIndex] = true
                                    }
                                }
                            }
                    }
                }
            }

            Spacer()

            // Pole tekstowe do wpisywania zgadywanego słowa
            TextField("Wpisz 5-literowe słowo", text: $currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onSubmit {
                    submitGuess()
                }

            Button(action: submitGuess) {
                Text("Zatwierdź")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .disabled(currentGuess.count != 5 || attempt >= 6)
            .padding()

            Spacer()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Koniec gry"), message: Text(alertMessage), dismissButton: .default(Text("OK"), action: resetGame))
        }
    }

    // Funkcja do wyświetlania liter w odpowiednich polach
    func letter(at index: Int, letterIndex: Int) -> String {
        guard index < attempt else { return "" }
        let guessArray = Array(guesses[index])
        return letterIndex < guessArray.count ? String(guessArray[letterIndex]) : ""
    }

    // Funkcja do koloryzowania pól na podstawie wyniku
    func color(at index: Int, letterIndex: Int) -> Color {
        guard index < attempt else { return Color.gray }
        let guessArray = Array(guesses[index])
        let secretArray = Array(secretWord)
        guard letterIndex < guessArray.count else { return Color.gray }

        if guessArray[letterIndex] == secretArray[letterIndex] {
            return Color.green // Litera poprawna i w dobrym miejscu
        } else if secretWord.contains(guessArray[letterIndex]) {
            return Color.yellow // Litera poprawna, ale w złym miejscu
        } else {
            return Color.gray // Litera nie występuje
        }
    }

    // Funkcja obsługująca zgadywanie
    func submitGuess() {
        guard currentGuess.count == 5 else { return }

        guesses[attempt] = currentGuess.lowercased()
        if currentGuess.lowercased() == secretWord {
            alertMessage = "Brawo! Zgadłeś słowo: \(secretWord)."
            showAlert = true
        } else if attempt == 5 {
            alertMessage = "Niestety, przegrałeś. Sekretne słowo to: \(secretWord)."
            showAlert = true
        }

        currentGuess = ""
        attempt += 1
    }

    // Resetowanie gry
    func resetGame() {
        secretWord = ["apple", "grape", "melon", "peach", "berry"].randomElement()!
        guesses = Array(repeating: "", count: 6)
        currentGuess = ""
        attempt = 0
        animationState = Array(repeating: false, count: 30)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

