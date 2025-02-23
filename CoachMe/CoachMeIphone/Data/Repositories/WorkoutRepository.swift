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
    
    func mockConfirmation(user: UserModel)->AnyPublisher<Void,RegisterError>{
        return apiService.mockConfirmationWorkouts(user: user)
    }
    
    func sendTrainingForConfirmation(user: UserModel, trainer: TrainerModel) -> AnyPublisher<Void, RegisterError>{
        return apiService.addTrainingForConfirmation(user: user, trainer: trainer)
    }
    
    func getTrainer() -> AnyPublisher<[TrainerModel], RegisterError>{
        return apiService.getTrainer()
    }
    
    func getStatusUserGYM(user: UserModel) -> AnyPublisher<UserModel.UserStatus, RegisterError> {
        return apiService.getUserStatusGYM(user: user)
    }
    
    func mockAddWorkoutsConfirmation (user: UserModel, workouts: [Stats]) -> AnyPublisher<[Stats], RegisterError>{
        return apiService.mockAddConfirmationfWorkouts(user: user, workouts: workouts)
    }
}
