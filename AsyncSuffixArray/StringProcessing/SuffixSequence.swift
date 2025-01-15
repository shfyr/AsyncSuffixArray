//
//  SuffixSequence.swift
//  SuffixArray
//
//  Created by Elizaveta on 25.12.2024.
//

struct SuffixIterator: IteratorProtocol {
    var text: String
    private var currentIndex: String.Index?

    init(text: String) {
        self.text = text
            .filter { $0.isLetter }
            .lowercased()

        currentIndex = text.startIndex
    }

    mutating func next() -> String? {
        guard let currentIndex,
              currentIndex < text.endIndex else { return nil }

        let suffix = text[currentIndex...]
        self.currentIndex = text.index(after: currentIndex)
        return String(suffix)
    }
}

struct SuffixSequence: Sequence {
    var text: String

    func makeIterator() -> SuffixIterator {
        SuffixIterator(text: text)
    }

    func getSuffixes() -> [String] {
        var iterator = makeIterator()
        var suffixes: [String] = []

        while let suffix = iterator.next() {
            suffixes.append(String(suffix))
        }

        return suffixes
    }
}
