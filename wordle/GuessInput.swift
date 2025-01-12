import SwiftUI

struct GuessInput: View {
    @ObservedObject var viewModel: WordleViewModel
    
    var body: some View {
        VStack {
            TextField("Wpisz 5-literowe słowo", text: $viewModel.currentGuess)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .onChange(of: viewModel.currentGuess) { newValue in
                    if newValue.count > 5 {
                        viewModel.currentGuess = String(newValue.prefix(5))
                    }
                }
                .onSubmit(viewModel.submitGuess)
            
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
        }
    }
}