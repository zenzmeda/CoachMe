//
//  RegisterRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Combine

enum RegisterError: Error {
    case alreadyExists
    case networkError
    case unknownError
    case userAbsentError
    case checkUserNameError
    case passwordDoNotMatch
    case emptyFields
    case userOrTrainerAbsent
    case emptyListOfTrainers
    
}

enum StatusUser{
    case alreadyExists
    case success
}



enum RegisterTrainer:Error{
    case trainerExists
    case coachCodeIncorrect
    case createTrainer
    case notTrainer
    case unknownError
    case errorSaveToLocalBase
}

protocol RegisterRepositoryProtocol{
    func saveUser(_ user: UserModel) -> AnyPublisher<UserModel, RegisterError>
    func saveTrainer(_ trainer: TrainerModel) -> AnyPublisher<TrainerModel, RegisterTrainer>
    func authenticationUser(_ userName: String, _ password: String) -> AnyPublisher<UserModel,RegisterError>
}
