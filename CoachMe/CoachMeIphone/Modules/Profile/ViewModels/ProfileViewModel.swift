//
//  ProfileViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation

class ProfileViewModel {
    private let repository: UserReposytoryProtocol
    
    init(repository: UserReposytoryProtocol) {
        self.repository = repository
    }
    
    func getUserData() -> UserModel? {
            return repository.fetchUser()
        }
    
    func getRepository() -> UserReposytoryProtocol {
           return repository
       }

    func fetchUser() {
        // Симуляция получения данных из базы или сетевого запроса
        // Для примера создадим пользователя вручную
//        let myprogress: [Stats] = []
//        let _ = UserModel(id: UUID(), name: "Vadim", avatar: "Empty", progress: myprogress, status: UserModel.UserStatus.inGym)
    }

    func getUserName() -> String {
        return getUserData()?.name ?? "Unknown"
    }

    func getUserAvatar() -> String {
        return getUserData()?.avatar ?? "default_avatar"
    }
}
