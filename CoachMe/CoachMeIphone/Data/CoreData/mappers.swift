//
//  mappers.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation
import CoreData

extension UserModel {
    // Преобразование UserModel в Core Data User
    func toCoreDataModel( context: NSManagedObjectContext) -> User {
        let user = User(context: context)
        user.id = self.id
        user.name = self.name
        user.avatar = self.avatar
        user.status = self.status.rawValue
        user.birthday = self.birthday
        user.email = self.email
        user.gender = self.gender == .male ? 1:0
        user.gym = self.gym.rawValue
        user.phoneNumber = self.phoneNumber
        user.userName = self.userName
        
        let progressSet = self.progress.map{$0.statsToCoreData(context: context)}
        user.statsData = NSSet(array: progressSet)
        return user
        
    }
}

extension User {
        func toUserModel() -> UserModel? {
            guard let id = self.id,
                  let name = self.name,
                  let avatar = self.avatar,
                  let statusString = self.status,
                  let birthday = self.birthday,
                  let email = self.email,
                  var gym = self.gym,
                  let phoneNumber = self.phoneNumber,
                  let userName = self.userName,
                  let status = UserModel.UserStatus(rawValue: statusString) else {
                return nil
            }
            let stats: [Stats] = self.statsData?.compactMap{(statsDataObject) -> Stats? in
                guard let statsData = statsDataObject as? StatsData else { return nil }
                return Stats(exerciseName: statsData.exerciseName ?? "", workingWeight: statsData.workingWeight, repetitions: statsData.repetitions, sets: statsData.sets, date: statsData.date ?? Date())
                      } ?? []
            
            var currentGYM = UserModel.GYM.Tulskaya
            if let DefaultGYM = UserModel.GYM(rawValue: gym){
                currentGYM = DefaultGYM
            }
         
            return UserModel(id: id, name: name, avatar: avatar, progress: stats, status: status, email: email, userName: userName, phoneNumber: phoneNumber, gender: self.gender == 1 ? UserModel.Gender.male : UserModel.Gender.female, birthday: birthday, gym: currentGYM)
        }
}

extension Stats {
    func statsToCoreData(context: NSManagedObjectContext) -> StatsData{
        let progress = StatsData(context: context)
        progress.date = self.date
        progress.exerciseName = self.exerciseName
        progress.repetitions = self.repetitions
        progress.sets = self.sets
        progress.workingWeight = self.workingWeight
        return progress
        
    }
}
