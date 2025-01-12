//
//  ContentView.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

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
            
            GuessGrid(viewModel: viewModel)
            
            Spacer()
            
            GuessInput(viewModel: viewModel)
        }
        .padding()
        .gesture(
            DragGesture(minimumDistance: 50, coordinateSpace: .local)
                .onEnded { value in
                    if value.translation.height > 0 {
                        viewModel.initiateGameReset()
                    }
                }
        )
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            if viewModel.shouldShowConfirmButtons {
                Button("TAK") { viewModel.confirmGameReset() }
                Button("ANULUJ", role: .cancel) { }
            } else {
                Button("OK") { viewModel.confirmGameReset() }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}