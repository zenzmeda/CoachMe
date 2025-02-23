//
//  StatsRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation
import Combine

class StatsRepository: StatsRepositoryProtocol{
    
    private let apiService: MockAPIService
    private let dataService: UserLocalDataSource
    
    init(apiService: MockAPIService, dataService: UserLocalDataSource) {
        self.apiService = apiService
        self.dataService = dataService
    }
    
    func saveStats(_ stats: Stats){
        
    }
    
    
    func fetchStats(user: UserModel) -> AnyPublisher<[Stats], RegisterError>{
        return apiService.fetchUsers()
            .tryMap{ users in
                guard let user = users.first(where: {$0.id == user.id}) else {
                    throw RegisterError.userAbsentError
                }
                return user.progress
            }
            .mapError{error in
                error as? RegisterError ?? RegisterError.unknownError}
            .eraseToAnyPublisher()
    }
    
   
    
}
