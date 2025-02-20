//
//  MockAPIService.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation
import Combine

class MockAPIService: APIServiceProtocol{
    private var users: [UserModel]
    private var trainer: [TrainerModel]
    
    let progress: [Stats]
    let arrayusers : [UserModel]
    let arraytrainer : [TrainerModel]
    
    let userTrainer: UserModel
    let currentUser: UserModel
    let user: UserModel
    
    let trainer1 = TrainerModel(id: UUID(), coachCode: "COACH001", userName: "Тренер Алексей")
    let trainer2 = TrainerModel(id: UUID(), coachCode: "COACH002", userName: "Тренер Ольга")
    let trainer3 = TrainerModel(id: UUID(), coachCode: "COACH003", userName: "Тренер Дмитрий")
    
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(users: [UserModel], trainer: [TrainerModel]) {
        self.users = users
        self.trainer = trainer
        
        self.progress = []
        
        self.userTrainer = UserModel(id: trainer1.id, name: "Алексей", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Тренер Алексей", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 1)
        
        self.currentUser = UserModel(id: UUID(), name: "Vadim", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
        
        self.user = UserModel(id: UUID(), name: "Vadim", avatar: "default", progress: progress, status: .outGym, email: "@", userName: "Vadim", phoneNumber: "898989898899", gender: .female, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
        
        self.arrayusers = [userTrainer, currentUser, user]
        self.arraytrainer = [trainer1, trainer2, trainer3]
        
        
    }
    
    func fetchUsers() -> Future<[UserModel], RegisterError>  {
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if self.users.isEmpty{
                    promise(.failure(.userAbsentError))
                } else {
                    promise(.success(self.users))
                }
            }
        }
    }
    func fetchUser(user: UserModel) -> AnyPublisher<UserModel, RegisterError>{
        return Future {promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if let user = self.users.first(where: {$0.id == user.id}){
                    promise (.success(user))
                }else {
                    promise(.failure(.userAbsentError))
                }
            }}.eraseToAnyPublisher()
    }
    
    func createUser(user: UserModel) -> Future<UserModel, RegisterError> {
        return Future{ promise in
            self.checkUserNameAvailability(userName: user.userName).sink(receiveCompletion:{completion in
                switch completion{
                case .finished:
                    break
                case .failure:
                    promise(.failure(.checkUserNameError))
                }
            }, receiveValue: { isAvailable in
                if isAvailable{
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        self.users.append(user)
                        promise(.success(user))
                    }
                }else{
                    promise(.failure(.alreadyExists))
                }
            }).store(in: &self.cancellables)
            
        }
    }
    
    func checkUserNameAvailability(userName: String) -> Future<Bool, Error> {
        let isAvailable = !users.contains(where: {$0.userName ==  userName})
        
        return Future {promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                promise(.success(isAvailable))
            }
        }
    }
    
    func checkCoachCode(newTrainer: TrainerModel) -> AnyPublisher<TrainerModel, RegisterTrainer>{
        return Future{ promise in
            if let existingTrainer = self.trainer.first(where: {$0.id == newTrainer.id}){
                if existingTrainer.coachCode == newTrainer.coachCode{
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        promise(.success(newTrainer))
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        promise(.failure(.coachCodeIncorrect))
                    }
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    promise(.failure(.notTrainer))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func saveWorkouts(workouts: [Stats], user: UserModel) -> AnyPublisher<Void, RegisterError> {
        return Future {promise in
            if let existingUser = self.users.first(where: {$0.id == user.id}){
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    existingUser.progress.append(contentsOf: workouts)
                    promise(.success(()))
                }} else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1){
                        promise(.failure(RegisterError.userAbsentError))
                    }
                                }
                                }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func addTrainingForConfirmation(user: UserModel, trainer: TrainerModel) -> AnyPublisher<Void, RegisterError>{
        return Future { promise in
            if let _ = self.users.first(where: {$0.id == user.id}), let existingTrainer = self.trainer.first(where: {$0.id == trainer.id}){
                DispatchQueue.main.asyncAfter(deadline:.now()+1){
                    print("Добавление тренировок...")
                    existingTrainer.addConfirmationTraining(user: user)
                    promise(.success(()))
                }
            }else {
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    print("Ошибка добавления тренировок на сервер")
                    promise(.failure(RegisterError.userOrTrainerAbsent))
                }
            } }.eraseToAnyPublisher()
    }
    
    func mockConfirmationWorkouts(user: UserModel) -> AnyPublisher<Void, RegisterError>{
        return Future{ promise in
            if let _ = self.users.first(where: {$0.id == user.id}){
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    self.users.forEach{
                        $0.progress.forEach{$0.status = .confirmed}
                    }
                    print("MockConfirmSuccess")
                    promise (.success(()))
                }
            }else{
                DispatchQueue.main.asyncAfter(deadline: .now()+1){
                    print("Error mockConfirm")
                    promise(.failure(RegisterError.networkError))
                }
            }}.eraseToAnyPublisher()
    }
    
    func getTrainer() -> AnyPublisher<[TrainerModel], RegisterError>{
        return Future { promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if self.trainer.isEmpty{
                    promise (.failure(.emptyListOfTrainers))
                }else {
                    promise(.success(self.trainer))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getUserStatusGYM(user: UserModel) -> AnyPublisher<UserModel.UserStatus, RegisterError> {
        return Future {promise in
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                if let currentUser = self.users.first(where: {$0.id == user.id}){
                    promise(.success(currentUser.status))
                }else {
                    promise(.failure(.userAbsentError))
                }
            }}.eraseToAnyPublisher()
    }
}
