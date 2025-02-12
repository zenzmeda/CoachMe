//
//  WorkoutsViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import Foundation

class WorkoutsViewModel {
    private let repository: WorkoutsRepository
    
    init(repository: WorkoutsRepository) {
        self.repository = repository
    }
    
   func getRepository () -> WorkoutsRepository{
        return repository
    }
}
