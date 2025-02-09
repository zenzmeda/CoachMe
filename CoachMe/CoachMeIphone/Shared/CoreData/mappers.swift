//
//  mappers.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation
import CoreData

extension UserData {
    // Преобразование UserModel в Core Data User
    func fromModel(userModel: UserModel, context: NSManagedObjectContext) {
        self.id = userModel.id
        self.name = userModel.name
        self.avatar = userModel.avatar
        self.status = userModel.status.rawValue
        if let progressData = try? JSONEncoder().encode(userModel.progress) {
            self.progress = progressData         }
    }
    
}
