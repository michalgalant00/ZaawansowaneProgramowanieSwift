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
            ContentView(viewModel: WordleViewModel())
        }
    }
}
