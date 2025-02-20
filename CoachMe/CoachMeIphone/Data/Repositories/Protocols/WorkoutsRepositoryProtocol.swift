//
//  WorkoutRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Combine

protocol WorkoutsRepositoryProtocol{
    func saveWorkouts(user: UserModel, workouts: [Stats]) -> AnyPublisher<[Stats], RegisterError>
    func sendTrainingForConfirmation(user: UserModel, trainer: TrainerModel) -> AnyPublisher<Void, RegisterError>
    func getTrainer() -> AnyPublisher<[TrainerModel], RegisterError>
    func mockConfirmation(user: UserModel)->AnyPublisher<Void,RegisterError>
    func getStatusUserGYM(user: UserModel)->AnyPublisher<UserModel.UserStatus,RegisterError>
}
