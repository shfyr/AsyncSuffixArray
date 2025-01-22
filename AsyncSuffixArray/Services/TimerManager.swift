//
//  TimerManager.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 22.01.2025.
//
import Combine

final class TimerManager: ObservableObject {
    @Published var secondsUntilNextExecution: Int = 20

    private var timerIsActive: Bool = false

    @MainActor
    func startTimer() {
        if timerIsActive { return }
        timerIsActive = true
        self.secondsUntilNextExecution = 20

        Task {
            while timerIsActive {
                self.secondsUntilNextExecution -= 1
                try? await Task.sleep(for: .seconds(1))
            }
        }
    }

    func stopTimer() {
        timerIsActive = false
    }
}

