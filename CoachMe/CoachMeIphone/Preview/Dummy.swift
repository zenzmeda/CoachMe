//
//  Dummy.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation

class DummyUserRepository: UserReposytoryProtocol {
    func fetchUser() -> UserModel {
        return UserModel(id: UUID(), name: "Vadim", avatar: "default_avatar", progress: [], status: .outGym,email: "dafult", userName: "default", phoneNumber: "default", gender: UserModel.Gender.male, birthday: Date(), gym: UserModel.GYM.KrasnyiProspect)
    }
    
    func updateUser(_ user: UserModel) {
        print("Обновление пользователя: \(user.name)")
    }
}

class DummyStatsRepository: StatsRepositoryProtocol {
    func fetchStats() -> [Stats]{
        return [
                    Stats(exerciseName: "Squat", workingWeight: 100, repetitions: 12, sets: 3, date: Date()),
                    Stats(exerciseName: "Deadlift", workingWeight: 120, repetitions: 10, sets: 3, date: Date())
                ]
    }
    func saveStats(_ stats: Stats) {
        
    }
}

