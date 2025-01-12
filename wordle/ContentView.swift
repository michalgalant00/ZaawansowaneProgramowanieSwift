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
                GuessRowView(index: index, viewModel: viewModel)
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
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 0 {
                        viewModel.showNewGameModal = true
                    }
                }
        )
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

