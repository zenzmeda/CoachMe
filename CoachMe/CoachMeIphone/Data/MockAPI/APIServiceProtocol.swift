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
}
