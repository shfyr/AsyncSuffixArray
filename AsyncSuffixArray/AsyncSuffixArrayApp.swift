//
//  AsyncSuffixArrayApp.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 15.01.2025.
//

import SwiftUI

@main
struct AsyncSuffixArrayApp: App {
    @State private var path: [Destinations] = []

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                TextFieldScreen(path: $path)
                    .navigationDestination(for: Destinations.self) { destination in
                        switch destination {
                        case let .result(resultDestination):
                            ResultScreen(presenter: ResultScreenPresenter(text: resultDestination.word))
                        }
                    }
            }
        }
    }
}
