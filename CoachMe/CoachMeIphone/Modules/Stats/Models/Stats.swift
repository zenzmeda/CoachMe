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
    var repetitions: Int16            // Количество повторений
    var sets: Int16                   // Количество подходов
    var date: Date                  // Дата тренировки
    var status: WorkoutStatus
    var exp: Int = 0
    
    init(exerciseName: String, workingWeight: Double, repetitions: Int16, sets: Int16, date: Date, status: WorkoutStatus, exp: Int = 0) {
        self.exerciseName = exerciseName
        self.workingWeight = workingWeight
        self.repetitions = repetitions
        self.sets = sets
        self.date = date
        self.status = status
        self.exp = exp
    }
    
    func updateProgress(workingWeight: Double, repetitions: Int16, sets: Int16) {
        self.workingWeight = workingWeight
        self.repetitions = repetitions
        self.sets = sets
    }
    
    func changeStatus(_ status: WorkoutStatus){
        self.status = status
    }
    
    func countCurrentEx() {
        self.exp = Stats.countEx(exerciseName: self.exerciseName, repetitions: self.repetitions, sets: self.sets)
    }
    
    static func countEx (exerciseName: String, repetitions: Int16, sets: Int16) -> Int {
        switch exerciseName{
        case "Жим лёжа":
            return 4 * Int(repetitions) * Int(sets)
        case "Отжимания":
            return 2 *  Int(repetitions) * Int(sets)
        case "Сведение рук":
            return 3 * Int(repetitions) * Int(sets)
        case "Приседания":
            return 1 * Int(repetitions) * Int(sets)
        case "Выпады":
            return 2 * Int(repetitions) * Int(sets)
        case "Сгибание ног":
            return 2 * Int(repetitions) * Int(sets)
        case "Становая тяга":
            return 4 * Int(repetitions) * Int(sets)
        case "Подтягивания":
            return 4 * Int(repetitions) * Int(sets)
        case "Тяга блока":
            return 2 * Int(repetitions) * Int(sets)
        default:
            return 0
        }
    }
    
    enum WorkoutStatus: Codable {
        case inProgress
        case awaitingConfirmation
        case confirmed
    }
}
