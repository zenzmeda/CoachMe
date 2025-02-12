//
//  LoginViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

class LoginViewModel {
    private let repository: RegisterRepositoryProtocol
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    
    func getRepository () -> RegisterRepositoryProtocol{
        return repository
    }
}
