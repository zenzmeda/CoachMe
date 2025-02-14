//
//  RegisterRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Combine

class RegisterRepository: RegisterRepositoryProtocol{
    
    private let apiService: APIServiceProtocol
    private let dataService: UserLocalDataSource
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: APIServiceProtocol, dataService: UserLocalDataSource) {
        self.apiService = apiService
        self.dataService = dataService
    }
    
    
    func saveUser(_ user: UserModel) -> AnyPublisher<UserModel, RegisterError> {
        do{
            
            let status = try dataService.saveUserToLocalDB(user: user)
            if status == .alreadyExists {
                return Fail(error: RegisterError.alreadyExists).eraseToAnyPublisher()
            }
            
            return apiService.createUser(user: user)
                .map {_ in user}
                .catch { error -> AnyPublisher<UserModel, RegisterError> in
                    if error == .alreadyExists{
                        print("Пользователь с таким именем уже зарегестрирован: \(error.localizedDescription)")
                        return Fail(error: RegisterError.alreadyExists).eraseToAnyPublisher()
                    }else {
                        print("Ошибка при отправке в API: \(error.localizedDescription)")
                        return Fail(error: RegisterError.networkError).eraseToAnyPublisher()
                    }
                }.eraseToAnyPublisher()
        }catch {
            print("Ошибка при сохранении в локальную БД: \(error.localizedDescription)")
            return Fail(error: RegisterError.unknownError).eraseToAnyPublisher()
        }
    }
    
    func saveTrainer(_ trainer: TrainerModel) -> AnyPublisher<TrainerModel, RegisterTrainer> {
        return apiService.checkCoachCode(newTrainer: trainer).flatMap{ validTrainer -> AnyPublisher<TrainerModel, RegisterTrainer> in
            do{
                _ = try self.dataService.saveTrainerToLocalDB(trainer: validTrainer)
                return Just(validTrainer)
                    .setFailureType(to: RegisterTrainer.self)
                    .eraseToAnyPublisher()
            }catch {
                return Fail(error: RegisterTrainer.errorSaveToLocalBase)
                    .eraseToAnyPublisher()
            }
        }.eraseToAnyPublisher()
    }
    
   
}
