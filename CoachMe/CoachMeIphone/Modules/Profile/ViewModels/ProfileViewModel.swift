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
    @Published var currentUser: UserModel
    @Published var isLoading: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: UserReposytoryProtocol, currentUser: UserModel) {
        self.repository = repository
        self.currentUser = currentUser
    }
    func getUser() ->UserModel {
        return currentUser
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
    
    func updateUser(user: UserModel) {
        isLoading = true // Устанавливаем флаг загрузки при начале обновления
        do{
            try repository.updateUser(user: user) // Вызываем асинхронный метод
                .sink(receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isLoading = false // Завершаем загрузку
                        print("Данные успешно обновлены")
                        
                    case .failure(_):
                        self?.isLoading = false // Завершаем загрузку
                    }
                }, receiveValue: { _ in
                    // Можно обработать значение, если оно нужно
                })
                .store(in: &cancellables) // Сохраняем подписку
        }catch{
            isLoading = false
        }
    }
    
    func fetchUser() throws {
        repository.fetchUser(user: currentUser).sink(receiveCompletion: {[weak self] completion in
            switch completion{
            case .finished:
                print("User update")
            case .failure(let error):
                do {
                    guard let user = try self?.repository.fetchUserFromDB(userName: self?.currentUser.userName ?? "") else {
                        print("No user found in DB")
                        return
                    }
                    self?.currentUser = user
                } catch {
                    print("Failed to fetch user from DB: \(error)")
                }
                print("\(error)")
            }}, receiveValue: {[weak self] value in
                self?.currentUser = value
                print("Current userUpdate \(value.name)")
            }).store(in: &cancellables)
    }
}
