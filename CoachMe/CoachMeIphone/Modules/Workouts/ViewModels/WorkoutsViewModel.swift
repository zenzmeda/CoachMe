//
//  WorkoutsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation
import Combine

class WorkoutsViewModel {
    private var currentWorkout: [Stats] = []
    private let repository: WorkoutsRepositoryProtocol
    private let currentUser: UserModel
    @Published private(set) var trainers: [TrainerModel] = []
    
    
    private var cancellables = Set<AnyCancellable>()
    
    
    init(repository: WorkoutsRepositoryProtocol, user: UserModel) {
        self.repository = repository
        self.currentUser = user
    }
    
    func getUser () ->UserModel {
        return currentUser
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
            currentWorkout[index].status = .awaitingConfirmation
        }
    }
    func deleteWorkout(_ workout: Stats) {
        if let index = currentWorkout.firstIndex(where: {
            $0.exerciseName == workout.exerciseName &&
            $0.workingWeight == workout.workingWeight &&
            $0.repetitions == workout.repetitions &&
            $0.sets == workout.sets
        }) {
            currentWorkout.remove(at: index)
        }
    }
    
    func saveWorkouts(user: UserModel, workouts: [Stats]) -> AnyPublisher<[Stats], RegisterError> {
        return repository.saveWorkouts(user: user, workouts: workouts)
            .handleEvents(receiveOutput: { savedWorkouts in
                print("Сохранено \(savedWorkouts.count) тренировок.")
            }, receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Сохранение прошло успешно.")
                case .failure(let error):
                    print("Ошибка при сохранении: \(error)")
                }
            })
            .eraseToAnyPublisher() // Не забываем вернуть AnyPublisher
    }
    
    func sendWorkoutsForConfirmation (user: UserModel, trainer: TrainerModel) {
        repository.sendTrainingForConfirmation(user: user, trainer: trainer).sink(receiveCompletion: {completion in
            switch completion{
            case .finished:
                print("Тренировки успешно отправились")
            case .failure(let error):
                print("Ошибка отправки тренировок \(error)")
            }}, receiveValue: { _ in }).store(in: &cancellables)
    }
    
    func fetchTrainers () {
        repository.getTrainer()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                if case let .failure(failure) = completion {
                    print("Ошибка загрузки тренеров: \(failure)")
                }}, receiveValue: {[weak self] trainers in
                    self?.trainers = trainers}).store(in: &cancellables)
    }
}
