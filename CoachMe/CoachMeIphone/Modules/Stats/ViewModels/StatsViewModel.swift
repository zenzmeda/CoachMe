//
//  StatsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation


class StatsViewModel {
    
    private var stats: [Stats]
    
    init(stats: [Stats]) {
        self.stats = stats
    }
    
    // Метод для загрузки статистики
    func loadStatsData() {
        // Пример статичных данных (в реальной ситуации тут будет запрос к API или к локальной базе данных)
        stats = [
            Stats(exerciseName: "Squat",workingWeight: 100, repetitions: 12, sets: 3, date: Date()),
            Stats(exerciseName: "Deadlift", workingWeight: 120, repetitions: 10, sets: 3,date: Date()),
            Stats(exerciseName: "Bench Press",workingWeight: 80, repetitions: 8, sets: 3, date: Date())
        ]
    }
}
