//
//  RegisterRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

class RegisterRepository: RegisterRepositoryProtocol{
    func saveUser(_ user: UserModel) -> StatusUser {
        return StatusUser.success
    }
}
