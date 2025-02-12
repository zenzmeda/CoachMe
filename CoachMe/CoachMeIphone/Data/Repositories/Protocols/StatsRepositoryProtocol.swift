//
//  StatsRepositoryProtocol.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

protocol StatsRepositoryProtocol{
    func fetchStats() -> [Stats]
    func saveStats(_ stats: Stats)
}
