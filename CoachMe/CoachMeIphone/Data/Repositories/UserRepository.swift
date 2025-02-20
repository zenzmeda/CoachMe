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
    
    
    func updateUser(_ user: UserModel) {
        
    }
}
