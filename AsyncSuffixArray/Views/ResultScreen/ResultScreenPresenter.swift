//
//  ResultScreenPresenter.swift
//  SuffixArray
//
//  Created by Elizaveta on 20.12.2024.
//
import SwiftUI

class ResultScreenPresenter: ObservableObject {
    @Published var text: String

    init(text: String) {
        self.text = text
    }

    var allSuffixes: [String] {
        getAllWords(text: text)
            .map { SuffixSequence(text: $0).getSuffixes() }
            .flatMap { $0 }
    }

    func getTopTen() -> [(String, Int)] {
        allSuffixes
            .filter { $0.count == 3 }
            .frequency
            .sorted {
                if $0.value == $1.value {
                    return $0.key < $1.key
                }
                return $0.value > $1.value
            }
            .prefix(10)
            .map { $0 }
    }

    func getAllWords(text: String) -> [String] {
        text.split(separator: " ")
            .map { String($0) }
    }
}
