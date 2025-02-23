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
    @Published var isLoadingTrainers = false
    @Published var UserInGym: UserModel.UserStatus = .outGym
    
    
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
            .eraseToAnyPublisher()
    }
    
    func mockConfirmation(){
        repository.mockConfirmation(user: currentUser).sink(receiveCompletion: {completion in
            switch completion{
            case .finished:
                print("MockConfirmation - success")
            case .failure(let error):
                print("Ошибка мокового подтверждения тренировок\(error)")
            }}, receiveValue: {_ in}).store(in: &cancellables)
    }
    
    func sendWorkoutsForConfirmation (user: UserModel, trainer: TrainerModel) {
        repository.sendTrainingForConfirmation(user: user, trainer: trainer).sink(receiveCompletion: {[weak self] completion in
            switch completion{
            case .finished:
                self?.mockConfirmation() // Отключить с реальным API
                print("Тренировки успешно отправились")
            case .failure(let error):
                print("Ошибка отправки тренировок \(error)")
            }}, receiveValue: { _ in }).store(in: &cancellables)
    }
    
    func fetchTrainers () {
        self.isLoadingTrainers = true
        repository.getTrainer()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else {return}
                switch completion{
                case .finished:
                    self.isLoadingTrainers = false
                case .failure(let error):
                    print("Ошибка загрузки тренеров: \(error)")
                    self.isLoadingTrainers = false
                }}, receiveValue: {[weak self] trainers in
                    self?.trainers = trainers}).store(in: &cancellables)
        print("Тренеры загружены: \(trainers)")
    }
    
    func getStatusUserGYM () {
        repository.getStatusUserGYM(user: currentUser).sink(receiveCompletion: { completion in
            switch completion{
            case .finished:
                print("status get")
            case .failure(let error):
                print("\(error)")
            }
        }, receiveValue: {[weak self] value in
            self?.currentUser.status = value
            self?.UserInGym = value
        }).store(in: &cancellables)
    }
    
    func mockAddWorkoutsConfirmation (user: UserModel, workouts: [Stats]){
        repository.mockAddWorkoutsConfirmation(user: user, workouts: workouts).sink(receiveCompletion: {completion in
            switch completion{
            case .finished: ()
            case .failure(let error):
                print("Ошибка имитациия добавления тернировок во вьюмодел")
            }}, receiveValue: {value in
                print ("Имитация добавления тренировок во вьюмодел завершена \(value)")}).store(in: &cancellables)
    }
}
