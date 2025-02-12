//
//  RegisterRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

enum StatusUser {
    case alreadyExists
    case success
    case error
    
}

protocol RegisterRepositoryProtocol{
    func saveUser (_ user: UserModel) -> StatusUser
}
