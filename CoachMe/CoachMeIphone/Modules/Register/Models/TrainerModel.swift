//
//  Trainer.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 14.02.2025.
//

import Foundation

class TrainerModel{
    let id: UUID
    let coachCode: String
    
    init(id: UUID, coachCode: String) {
        self.id = id
        self.coachCode = coachCode
    }
}
