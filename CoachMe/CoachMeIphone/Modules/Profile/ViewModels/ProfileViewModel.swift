//
//  ProfileViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation

class ProfileViewModel {
    private var user: UserModel?

    func fetchUser() {
        // Симуляция получения данных из базы или сетевого запроса
        // Для примера создадим пользователя вручную
        let myprogress: [Stats] = []
        user = UserModel(id: UUID(), name: "Vadim", avatar: "Empty", progress: myprogress, status: UserModel.UserStatus.inGym)
    }

    func getUserName() -> String {
        return user?.name ?? "Unknown"
    }

    func getUserAvatar() -> String {
        return user?.avatar ?? "default_avatar"
    }
}
