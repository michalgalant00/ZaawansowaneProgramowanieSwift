import SwiftUI

struct GuessRowView: View {
    let index: Int
    @ObservedObject var viewModel: WordleViewModel

    var body: some View {
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
                                viewModel.setAnimationState(at: index * 5 + letterIndex, to: true)
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
}