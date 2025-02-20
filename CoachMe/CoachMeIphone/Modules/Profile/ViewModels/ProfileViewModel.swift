//
//  ProfileViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import Foundation
import Combine

class ProfileViewModel {
    private let repository: UserReposytoryProtocol
    private var currentUser: UserModel
    
    private var cancellable = Set<AnyCancellable>()
    
    init(repository: UserReposytoryProtocol, currentUser: UserModel) {
        self.repository = repository
        self.currentUser = currentUser
    }
    
    func getRepository() -> UserReposytoryProtocol {
           return repository
       }
    
    func fetchUserFromDB (userName: String) throws{
        do{
            try currentUser = repository.fetchUserFromDB(userName: userName)
        }catch{
            print("Ошибка запроса пользователя в БД: \(error.localizedDescription)")
        }
    }

    func fetchUser() {
        repository.fetchUser(user: currentUser).sink(receiveCompletion: {completion in
            switch completion{
            case .finished:
                print("User update")
            case .failure(let error):
                print("\(error)")
            }}, receiveValue: {[weak self] value in
                self?.currentUser = value
            }).store(in: &cancellable)
    }
}
