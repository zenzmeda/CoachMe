//
//  UserData.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation
import CoreData

// Сущность пользователя для Core Data
@objc(UserData)
public class UserData: NSManagedObject {
    // Здесь автоматически генерируются свойства
}
extension UserData {
    // Запрос для получения всех пользователей
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserData> {
        return NSFetchRequest<UserData>(entityName: "UserData")
    }
    // Преобразуем свойства сущности в атрибуты Core Data
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var avatar: String?  // Это может быть URL или имя локального изображения
    @NSManaged public var progress: Data?  // Можно хранить прогресс в виде сериализованного массива
    @NSManaged public var status: String?  // Состояние пользователя как строка (например, "inGym", "outGym")
    
    // Преобразуем статус в типизированный enum
    var userStatus: UserStatus {
        get {
            guard let status = status else { return .outGym }
            return UserStatus(rawValue: status) ?? .outGym
        }
        set {
            status = newValue.rawValue
        }
    }
    enum UserStatus: String {
        case inGym = "inGym"
        case outGym = "outGym"
        case awaitingTrainer = "awaitingTrainer"
    }
    // Инициализация с основными аттрибутами
    func configure(id: UUID, name: String, avatar: String, progress: [Stats], status: UserStatus) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.progress = try? JSONEncoder().encode(progress) // Сериализация массива прогресса
        self.status = status.rawValue
    }
}

