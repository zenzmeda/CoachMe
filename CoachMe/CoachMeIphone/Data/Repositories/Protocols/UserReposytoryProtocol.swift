//
//  UserReposytoryProtocol.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

protocol UserReposytoryProtocol{
   func fetchUser() -> UserModel
    func updateUser (_ user: UserModel)
}
