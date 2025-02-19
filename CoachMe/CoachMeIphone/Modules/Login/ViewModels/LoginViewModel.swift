//
//  LoginViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Combine

class LoginViewModel {
    private let repository: RegisterRepositoryProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    
    func getRepository () -> RegisterRepositoryProtocol{
        return repository
    }
    
    
    func authentication (userName: String?, password: String? ) -> AnyPublisher <UserModel, RegisterError>{
        guard let userName = userName, let password = password else{ return Fail(error: RegisterError.emptyFields).eraseToAnyPublisher()}
        guard !userName.isEmpty, !password.isEmpty else { return Fail(error: RegisterError.emptyFields).eraseToAnyPublisher()}
        
        return repository.authenticationUser(userName, password)
            .map {user in
                print("User authenticated: \(user)")
                return user}
            .catch{ error in
                print("Authentication failed with error: \(error)")
                return Fail<UserModel, RegisterError>(error: error).eraseToAnyPublisher()
            }.eraseToAnyPublisher()
    }
}
