//
//  StatsRepositoryProtocol.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//

import Combine

protocol StatsRepositoryProtocol{
    func fetchStats(user: UserModel) -> AnyPublisher<[Stats], RegisterError>
    func saveStats(_ stats: Stats)
}
