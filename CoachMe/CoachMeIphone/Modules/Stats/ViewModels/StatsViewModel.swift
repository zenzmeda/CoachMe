//
//  StatsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Foundation


class StatsViewModel {
    
    private let repository: StatsRepositoryProtocol
    
    init(repository: StatsRepositoryProtocol) {
        self.repository = repository
    }
    
    private func getData() -> [Stats]{
        return repository.fetchStats()
    }
    
    func saveStat(_ stat: Stats) {
            repository.saveStats(stat)
        }
    
    // Метод для загрузки статистики
    func loadStatsData() {
       
    }
    
    func getRepository () -> StatsRepositoryProtocol{
        return repository
    }
}
