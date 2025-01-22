//
//  JobQueue.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 22.01.2025.
//

import Combine
import Foundation

class JobQueue: ObservableObject {
    @Published private var queue: [Job] = []
    var scheduler: JobScheduler?

    func setScheduler(timerManager: TimerManager) {
        scheduler = JobScheduler(jobQueue: self, timerManager: timerManager)
    }

    func addJob(text: String, task: @escaping (String) async -> Void) {
        queue.append(Job(id: UUID(), text: text, task: task))
    }

    func getAllJobs() -> [Job] {
        queue
    }

    func executeAllJobs() {
        for job in queue {
            Task {
                await executeJob(job)
            }
        }
    }

    private func executeJob(_ job: Job) async {
        if let index = queue.firstIndex(where: { $0.id == job.id }) {
            let job = queue[index]
            let startTime = Date()

            await job.task(job.text)

            Task { @MainActor in
                queue[index].duration = Date().timeIntervalSince(startTime)
            }
        }
    }
}
