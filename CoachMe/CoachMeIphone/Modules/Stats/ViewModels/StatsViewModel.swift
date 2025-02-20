//
//  StatsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation
import Combine


class StatsViewModel {
    
    private let repository: StatsRepositoryProtocol
    private let user: UserModel
    @Published var currentStats: [Stats] = []
    @Published var error: Error? = nil
    @Published var level: Int = 1
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: StatsRepositoryProtocol, user: UserModel) {
        self.repository = repository
        self.user = user
    }
    
    func getCurrentExp () -> Int {
        let filterProgress = user.progress.filter{$0.status == .confirmed}
        filterProgress.forEach{$0.countCurrentEx()}
        
        return filterProgress.reduce(0) {$0 + $1.exp}
    }
    
    func experienceForLevel(level: Int) -> Int {
        return 100 * Int(pow(2.0, Double(level - 1)))  // Используем переданный level
    }

    func getExpForNextLevel() -> Int {
        let experienceForNextLevel = experienceForLevel(level: self.level) // Вызываем исправленный метод
        let currentExp = self.getCurrentExp()
        return experienceForNextLevel - currentExp
    }
    
    func getLevelSync() -> Int {
        return level
    }
    
    func getLevel() ->Future<Int, RegisterError>{
        return Future {[weak self] promise in
            guard let self = self else {
                promise(.failure(.unknownError)) // Добавь ошибку, если self nil
                       return
                   }
            self.loadStatsData()
                .sink(receiveCompletion: {completion in
                    switch completion{
                    case .finished:
                        let currentExp = self.getCurrentExp()
                        var newlevel = 1
                        while self.experienceForLevel(level: newlevel) <= currentExp {
                            newlevel += 1
                        }
                        promise(.success(newlevel))
                    case .failure(let registerError):
                        promise(.failure(registerError))
                    }}, receiveValue: {_ in}).store(in: &self.cancellables)
        }
    }
    
    func loadStatsData() -> Future<Void, RegisterError> {
        return Future { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknownError)) // Обработай ошибку, если self = nil
                return
            }
            
            self.repository.fetchStats(user: self.user)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Данные успешно загружены")
                        promise(.success(())) // Вызываем promise только после успешного завершения
                    case .failure(let registerError):
                        self.error = registerError
                        print("Ошибка загрузки: \(registerError)")
                        promise(.failure(registerError))
                    }
                }, receiveValue: { stat in
                    self.currentStats = stat
                    print("Полученные данные во вьюмодель: \(stat)")
                    
                    // Проверяем, есть ли currentStats
                    print("currentStats теперь: \(String(describing: self.currentStats))")
                    
                    // Получаем текущий опыт
                    let currentExp = self.getCurrentExp()
                    print("Текущий опыт: \(currentExp)")
                    
                    var newLevel = 1
                    
                    // Проверяем, как изменяется newLevel
                    while self.experienceForLevel(level: newLevel) <= currentExp {
                        print("Опыт для уровня \(newLevel): \(self.experienceForLevel(level: newLevel))")
                        newLevel += 1
                    }
                    
                    self.level = newLevel
                    print("Новый уровень: \(newLevel)")
                }).store(in: &self.cancellables)
        }
    }


    
    func saveStat(_ stat: Stats) {
            repository.saveStats(stat)
        }
    
    
    func getRepository () -> StatsRepositoryProtocol{
        return repository
    }
}
