//
//  Destinations.swift
//  SuffixArray
//
//  Created by Elizaveta on 20.12.2024.
//

enum Destinations: Hashable {
    case result(destination: ResultDestination)
    case history
}

struct ResultDestination: Hashable {
    let word: String
}
