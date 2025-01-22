//
//  Job.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 15.01.2025.
//

import Foundation

struct Job {
    let id: UUID
    let text: String
    let task: (_: String) async -> Void
    var duration: TimeInterval?
}
