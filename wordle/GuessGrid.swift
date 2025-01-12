import SwiftUI

struct GuessGrid: View {
    @ObservedObject var viewModel: WordleViewModel
    
    var body: some View {
        VStack {
            ForEach(0..<6, id: \.self) { index in
                GuessRowView(index: index, viewModel: viewModel)
            }
        }
    }
}