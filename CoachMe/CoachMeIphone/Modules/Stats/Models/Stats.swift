//
//  ExerciseProgress.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//
import Foundation

class Stats: Codable{
    var exerciseName: String        // Название упражнения
    var workingWeight: Double       // Рабочий вес
    var repetitions: Int            // Количество повторений
    var sets: Int                   // Количество подходов
    var date: Date                  // Дата тренировки
    
    init(exerciseName: String, workingWeight: Double, repetitions: Int, sets: Int, date: Date) {
        self.exerciseName = exerciseName
        self.workingWeight = workingWeight
        self.repetitions = repetitions
        self.sets = sets
        self.date = date
    }
    
    func updateProgress(workingWeight: Double, repetitions: Int, sets: Int) {
        self.workingWeight = workingWeight
        self.repetitions = repetitions
        self.sets = sets
    }
}
