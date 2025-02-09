//
//  User.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

import Foundation

class UserModel{
    var id: UUID
    var name: String
    var avatar: String
    var progress: [Stats]
    var status: UserStatus
    
    init(id: UUID, name: String, avatar: String, progress: [Stats], status: UserStatus) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.progress = progress
        self.status = status
    }
    
    enum UserStatus: String {
        case inGym = "inGym"           // Пользователь в клубе
        case outGym = "outGym"         // Пользователь не в клубе
        case awaitingTrainer = "awaitingTrainer"  // Ожидает тренера для подтверждения
    }
    
    func updateStatus(newStatus: UserStatus) {
        self.status = newStatus
    }
}
