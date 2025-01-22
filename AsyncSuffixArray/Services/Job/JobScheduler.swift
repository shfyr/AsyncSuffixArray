//
//  JobScheduler.swift
//  AsyncSuffixArray
//
//  Created by Elizaveta on 22.01.2025.


actor JobScheduler {
    private var jobQueue: JobQueue
    private var timerManager: TimerManager
    
    init(jobQueue: JobQueue, timerManager: TimerManager) {
        self.jobQueue = jobQueue
        self.timerManager = timerManager
    }

    func executePeriodically() {
        Task {
            await timerManager.startTimer()

            while true {
                let remainingTime = timerManager.secondsUntilNextExecution
                if remainingTime > 0 {
                    
                    jobQueue.executeAllJobs()
                    try? await Task.sleep(for: .seconds(remainingTime))

                } else {
                    timerManager.stopTimer()
                    try? await Task.sleep(for: .seconds(2))
                    
                    await timerManager.startTimer()
                }
            }
        }
    }
}
