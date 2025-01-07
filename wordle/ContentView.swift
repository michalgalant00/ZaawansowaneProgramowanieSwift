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
            Text("Wordle")
                .font(.largeTitle)
                .bold()
                .padding()

            Spacer()

            // Wyświetlanie wyników zgadywania
            ForEach(0..<6, id: \.self) { index in
                HStack {
                    ForEach(0..<5, id: \.self) { letterIndex in
                        Text(viewModel.letter(at: index, letterIndex: letterIndex))
                            .frame(width: 50, height: 50)
                            .background(viewModel.color(at: index, letterIndex: letterIndex))
                            .cornerRadius(8)
                            .foregroundColor(.white)
                            .font(.title)
                            .rotation3DEffect(
                                .degrees(viewModel.animationState[index * 5 + letterIndex] ? 360 : 0),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .animation(
                                .easeInOut(duration: 0.6)
                                    .delay(Double(letterIndex) * 0.2),
                                value: viewModel.animationState[index * 5 + letterIndex]
                            )
                            .onAppear {
                                if index < viewModel.attempt {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(letterIndex) * 0.2) {
                                        viewModel.animationState[index * 5 + letterIndex] = true
                                    }
                                }
                            }
                    }
                }
                .offset(x: viewModel.correctGuessAnimationState[index] ? 10 : 0)
                .animation(
                    .easeInOut(duration: 0.2)
                        .repeatCount(3, autoreverses: true)
                        .delay(Double(index) * 0.1),
                    value: viewModel.correctGuessAnimationState[index]
                )
            }

            Spacer()

            // Pole tekstowe do wpisywania zgadywanego słowa
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Koniec gry"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK"), action: viewModel.resetGame))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: WordleViewModel())
    }
}

