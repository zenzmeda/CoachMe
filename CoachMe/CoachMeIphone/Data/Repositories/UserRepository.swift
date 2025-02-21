//
//  UserRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation
import Combine


class UserRepository: UserReposytoryProtocol{
    
    private let apiService: MockAPIService
    private let dataService: UserLocalDataSource
    
    private var cancellable = Set<AnyCancellable>()
    
    init(apiService: MockAPIService, dataService: UserLocalDataSource) {
        self.apiService = apiService
        self.dataService = dataService
    }
    
    
    func fetchUser(user: UserModel) -> AnyPublisher<UserModel, RegisterError> {
        return apiService.fetchUser(user: user)
    }
    
    func fetchUserFromDB(userName: String) throws -> UserModel {
        try dataService.getUser(userName: userName)
    }
    
    
    func updateUser(user: UserModel) throws -> AnyPublisher<Void, RegisterError> {
        return Future{ promise in
            do{
                let result = try self.dataService.updateUser(user: user)
                switch result{
                case .success:
                    self.apiService.updateUser(user: user)
                        .sink(receiveCompletion: {completion in
                            switch completion{
                                
                            case .finished:
                                print("Данные обновлены в сети")
                                promise(.success(()))
                                
                            case .failure(_):
                                print("Ошибка обновления данных в сети")
                                promise(.failure(.networkError))
                            }
                        }, receiveValue: {_ in}).store(in: &self.cancellable)
                case .failure(let error):
                    promise(.failure(error))
                }
            }catch {
                promise(.failure(.userAbsentError))
            }
        }.eraseToAnyPublisher()
    }
    }



