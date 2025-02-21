//
//  UserReposytoryProtocol.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Combine

protocol UserReposytoryProtocol{
    func fetchUser(user: UserModel) -> AnyPublisher<UserModel, RegisterError>
    func fetchUserFromDB (userName: String) throws ->  UserModel
    func updateUser (user: UserModel) throws -> AnyPublisher<Void, RegisterError>
}
