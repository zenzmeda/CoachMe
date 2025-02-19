//
//  Untitled.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation
import Combine

class WorkoutsRepository: WorkoutsRepositoryProtocol {
    
    private let dataService: UserLocalDataSource
    private let apiService: MockAPIService
    
    init(dataService: UserLocalDataSource, apiService: MockAPIService) {
        self.dataService = dataService
        self.apiService = apiService
    }
  
    func fetchWorkouts() -> [Stats] {
        // Симуляция загрузки данных. В реальности можно загрузить данные из базы данных или API
        let sampleStats = [
                    Stats(exerciseName: "Push-up", workingWeight: 0, repetitions: 15, sets: 3, date: Date()),
                    Stats(exerciseName: "Squats", workingWeight: 50, repetitions: 12, sets: 4, date: Date()),
                    Stats(exerciseName: "Deadlift", workingWeight: 100, repetitions: 10, sets: 3, date: Date())
                ]

        return sampleStats
    }
    
    func saveWorkouts(user: UserModel, workouts: [Stats]) -> AnyPublisher<[Stats], RegisterError> {
        do{
            let status = try dataService.saveWorkoutsToLocalDB(workouts: workouts, user: user)
            
            switch status{
            case .success:
                return apiService.saveWorkouts(workouts: workouts, user: user).map
                {  _ in
                    return workouts
                }
                .catch {error -> AnyPublisher<[Stats], RegisterError> in
                    print("Ошибка при отправке тренировки на сервер: \(error)")
                    return Fail(error: RegisterError.networkError).eraseToAnyPublisher()
                }.eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
                
            }
        }
        catch{
            return Fail(error: RegisterError.unknownError).eraseToAnyPublisher()
        }
    }
}
