//
//  Trainer.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 14.02.2025.
//

import Foundation

class TrainerModel{
    let id: UUID
    let userName: String
    let coachCode: String
    var confirmationTraining: [ConfirmationTraining] = []
    
    init(id: UUID, coachCode: String, userName: String) {
        self.id = id
        self.coachCode = coachCode
        self.userName = userName
    }
    
    func addConfirmationTraining (user: UserModel){
        let awaitingWorkouts = user.progress.filter{$0.status == .awaitingConfirmation}
        let newConfirmationTraining = ConfirmationTraining(userId: user.id, workouts: awaitingWorkouts)
        confirmationTraining.append(newConfirmationTraining)
    }
    
    struct ConfirmationTraining {
        let userId: UUID
        let workouts: [Stats]
    }
}
