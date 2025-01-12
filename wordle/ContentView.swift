//
//  ContentView.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: WordleViewModel

    var body: some View {
        VStack {
            // Title of the game
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding()

            Spacer()

            // Displaying the guesses
            ForEach(0..<6, id: \.self) { index in
                GuessRowView(index: index, viewModel: viewModel)
            }

            Spacer()

            // Text field for entering the guessed word
            TextField("Wpisz 5-literowe słowo", text: $viewModel.currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.currentGuess) { newValue in
                    if newValue.count > 5 {
                        viewModel.currentGuess = String(newValue.prefix(5))
                    }
                }
                .onSubmit {
                    viewModel.submitGuess()
                }

            // Button to submit the guess
            Button(action: viewModel.submitGuess) {
                Text("Zatwierdź")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
                    .foregroundColor(.white)
            }
            .disabled(viewModel.currentGuess.count != 5 || viewModel.attempt >= 6)
            .padding()

            Spacer()
        }
        .padding()
        // Alert for end of game
        .alert(isPresented: $viewModel.showEndGameModal) {
            Alert(title: Text("Koniec gry"), message: Text(viewModel.endGameMessage), dismissButton: .default(Text("OK"), action: viewModel.startNewGame))
        }
        // Gesture for starting a new game
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 0 {
                        viewModel.showNewGameModal = true
                    }
                }
        )
        // Alert for confirming new game
        .alert(isPresented: $viewModel.showNewGameModal) {
            Alert(
                title: Text("Czy chcesz rozpocząć nową grę?"),
                primaryButton: .default(Text("TAK"), action: viewModel.startNewGame),
                secondaryButton: .cancel(Text("ANULUJ"))
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WordleViewModel())
    }
}

