//
//  wordleApp.swift
//  wordle
//
//  Created by walter on 09/12/2024.
//

import SwiftUI

@main
struct wordleApp: App {
    var body: some Scene {
        WindowGroup {
            // Initialize the ContentView with WordleViewModel
            ContentView(viewModel: WordleViewModel())
        }
    }
}
