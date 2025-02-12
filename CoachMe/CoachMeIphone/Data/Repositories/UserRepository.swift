//
//  UserRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation

class UserRepository: UserReposytoryProtocol{
    func fetchUser() -> UserModel {
        return UserModel(id: UUID(), name: "Vadim", avatar: "default_avatar", progress: [], status: .outGym,email: "dafult", userName: "default", phoneNumber: "default", gender: UserModel.Gender.male, birthday: Date(), gym: UserModel.GYM.KrasnyiProspect)
    }
    func updateUser(_ user: UserModel) {
        
    }
}
