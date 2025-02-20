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
    var email: String
    var userName: String
    var phoneNumber: String
    var gender: Gender
    var birthday: Date
    var gym: GYM
    var statusTrainer: Int16
    var password: String?
    var level: Int = 1
    
    init(id: UUID, name: String, avatar: String, progress: [Stats], status: UserStatus, email: String, userName: String, phoneNumber: String, gender: Gender, birthday: Date, gym: GYM, statusTrainer: Int16, password: String? = nil) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.progress = progress
        self.status = status
        self.email = email
        self.userName = userName
        self.phoneNumber = phoneNumber
        self.gender = gender
        self.birthday = birthday
        self.gym = gym
        self.statusTrainer = statusTrainer
        self.password = password
    }
    
    enum GYM: String {
        case Tulskaya = "Tulskaya"
        case Shabolovka = "Shabolovka"
        case KrasnyiProspect = "KrasnyiProspect"
    }
    
    enum Gender {
        case male
        case female
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
