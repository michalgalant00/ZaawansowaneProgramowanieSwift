import SwiftUI

struct GuessRowView: View {
    let index: Int
    @ObservedObject var viewModel: WordleViewModel

    var body: some View {
        HStack {
            ForEach(0..<5, id: \.self) { letterIndex in
                let isFlipped = $viewModel.flipAnimationStates[index * 5 + letterIndex]
                let front = {
                    Text(viewModel.letter(at: index, column: letterIndex))
                        .frame(width: 50, height: 50)
                        .background(Color.gray)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.title)
                }
                let back = {
                    Text(viewModel.letter(at: index, column: letterIndex))
                        .frame(width: 50, height: 50)
                        .background(viewModel.color(at: index, column: letterIndex))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .font(.title)
                }
                Flip(isFlipped: isFlipped, front: front, back: back)
                    .onAppear {
                        if index < viewModel.attempt {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(letterIndex) * 0.2) {
                                viewModel.setAnimationState(at: index * 5 + letterIndex, to: true)
                            }
                        }
                    }
            }
        }
        .offset(x: viewModel.correctGuessAnimationStates[index] ? 10 : 0)
        .animation(
            .easeInOut(duration: 0.2)
                .repeatCount(3, autoreverses: true)
                .delay(Double(index) * 0.1),
            value: viewModel.correctGuessAnimationStates[index]
        )
    }
}