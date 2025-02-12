//
//  Untitled.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation

class WorkoutsRepository: WorkoutsRepositoryProtocol {
  
    func fetchWorkouts() -> [Stats] {
        // Симуляция загрузки данных. В реальности можно загрузить данные из базы данных или API
        let sampleStats = [
                    Stats(exerciseName: "Push-up", workingWeight: 0, repetitions: 15, sets: 3, date: Date()),
                    Stats(exerciseName: "Squats", workingWeight: 50, repetitions: 12, sets: 4, date: Date()),
                    Stats(exerciseName: "Deadlift", workingWeight: 100, repetitions: 10, sets: 3, date: Date())
                ]

        return sampleStats
    }
    
    func saveWorkouts () {
        
    }
}
