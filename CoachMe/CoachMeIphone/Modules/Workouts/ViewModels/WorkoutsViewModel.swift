//
//  WorkoutsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation

class WorkoutsViewModel {
    private var currentWorkout: [Stats] = []
    private let repository: WorkoutsRepositoryProtocol
    
    init(repository: WorkoutsRepositoryProtocol) {
        self.repository = repository
    }
    
    func getCurrentWorckout () -> [Stats]{
        return currentWorkout
    }
    
    func addWorkoutToCurrentWokkout (_ workout: Stats) {
        currentWorkout.append(workout)
    }
    
    func clearCurrentWorkouts () {
        currentWorkout.removeAll()
    }
    
    
    func getRepository () -> WorkoutsRepositoryProtocol{
        return repository
    }
    
    func updateWorkout(_ workout: Stats, newWeight: Int, newRepetitions: Int, newSets: Int) {
        if let index = currentWorkout.firstIndex(where: { $0.exerciseName == workout.exerciseName }) {
            currentWorkout[index].workingWeight = Double(newWeight)
            currentWorkout[index].repetitions = Int16(newRepetitions)
            currentWorkout[index].sets = Int16(newSets)
        }
    }
}
