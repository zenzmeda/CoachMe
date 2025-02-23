//
//  APIProtocol.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Combine

protocol APIServiceProtocol{
    func fetchUsers() -> Future<[UserModel], RegisterError>
    func createUser(user: UserModel) -> Future<UserModel, RegisterError>
    func checkUserNameAvailability(userName: String) -> Future<Bool, Error>
    func checkCoachCode(newTrainer: TrainerModel) -> AnyPublisher<TrainerModel, RegisterTrainer>
    func saveWorkouts (workouts: [Stats], user: UserModel) -> AnyPublisher<Void, RegisterError>
    func addTrainingForConfirmation(user: UserModel, trainer: TrainerModel) -> AnyPublisher<Void, RegisterError>
    func getTrainer() -> AnyPublisher<[TrainerModel], RegisterError>
    func mockConfirmationWorkouts(user: UserModel) -> AnyPublisher<Void, RegisterError>
    func getUserStatusGYM(user: UserModel)->AnyPublisher<UserModel.UserStatus,RegisterError>
    func fetchUser(user: UserModel) -> AnyPublisher<UserModel, RegisterError>
    func updateUser (user: UserModel) -> AnyPublisher<Void, RegisterError>
    func mockAddConfirmationfWorkouts(user: UserModel, workouts: [Stats]) -> AnyPublisher<[Stats], RegisterError>
}
