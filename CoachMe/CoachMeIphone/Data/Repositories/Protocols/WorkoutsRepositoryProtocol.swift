//
//  WorkoutRepository.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

protocol WorkoutsRepositoryProtocol{
    func fetchWorkouts () -> [Stats]
    func saveWorkouts ()
    
}
