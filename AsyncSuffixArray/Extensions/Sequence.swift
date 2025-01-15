//
//  Sequence.swift
//  SuffixArray
//
//  Created by Elizaveta on 25.12.2024.
//

extension Sequence where Element: Hashable {
    var frequency: [Element: Int] {
        reduce(into: [:]) { newDictionary, item in
            newDictionary[item, default: 0] += 1
        }
    }
}
