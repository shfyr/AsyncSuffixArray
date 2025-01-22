//
//  HistoryScreen.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 15.01.2025.
//

import SwiftUI

struct HistoryScreen: View {
    @StateObject private var jobQueue = JobQueue()
    @State private var searchHistory: [String] = []
    @StateObject private var timerManager = TimerManager()

    var body: some View {
        VStack {
            Text("Seconds until next executions: \(timerManager.secondsUntilNextExecution)")

            List {
                ForEach(searchHistory, id: \.self) { text in
                    VStack(alignment: .leading) {
                        Text("Text: \(text)")
                            .font(.headline)
                        Text("Execution time: \(getJobDuration(for: text)) seconds")
                            .font(.subheadline)
                    }
                    .listRowBackground(getExecutionTimeColor(for: text))
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Search History")
        }
        .onAppear {
            loadSearchHistory()
            addJobsToQueue()
        }
    }

    private func loadSearchHistory() {
        if let savedWords = UserDefaults.standard.array(forKey: "searchHistory") as? [String] {
            searchHistory = savedWords
        }
    }

    private func addJobsToQueue() {
        for word in searchHistory {
            let _ = jobQueue.addJob(text: word, task: findAllSuffixes)
        }
        jobQueue.setScheduler(timerManager: timerManager)

        Task {
            await jobQueue.scheduler?.executePeriodically()
        }
    }

    private func getJobDuration(for text: String) -> String {
        if let job = jobQueue.getAllJobs().first(where: { $0.text == text }) {
            return String(job.duration ?? 0.0)
        }
        return "0.0"
    }

    private func findAllSuffixes(text: String) async {
        let _ = text.split(separator: " ")
            .map { String($0) }
            .map { SuffixSequence(text: $0).getSuffixes() }
            .flatMap { $0 }
    }

    private func getExecutionTimeColor(for text: String) -> Color {
        if let job = jobQueue.getAllJobs().first(where: { $0.text == text }),
           let duration = job.duration
        {
            let allDurations = jobQueue.getAllJobs().compactMap { $0.duration }
            guard let minDuration = allDurations.min(), let maxDuration = allDurations.max() else {
                return .gray
            }

            let normalizedValue = (duration - minDuration) / (maxDuration - minDuration)
            return Color(
                red: normalizedValue,
                green: 1.0 - normalizedValue,
                blue: 0.0
            )
        }
        return .gray
    }
}

#Preview {
    HistoryScreen()
}
