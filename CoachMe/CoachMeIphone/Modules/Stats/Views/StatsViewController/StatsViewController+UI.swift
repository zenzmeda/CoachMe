//
//  StatsViewController+UI.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 21.02.2025.
//

import UIKit

#Preview {
    let workout1 = Stats(exerciseName: "Отжимания", workingWeight: 10, repetitions: 1000, sets: 3, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Отжимания", repetitions: 2, sets: 2))
    let workout2 = Stats(exerciseName: "Подтягивания", workingWeight: 10, repetitions: 2, sets: 5, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Подтягивания", repetitions: 2, sets: 2))
    let workout3 = Stats(exerciseName: "Становая тяга", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .inProgress)
    let workout4 = Stats(exerciseName: "Приседания", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .awaitingConfirmation)
    let progress: [Stats] = [workout1, workout2, workout3, workout4]
        let trainer1 = TrainerModel(id: UUID(), coachCode: "COACH001", userName: "Тренер Алексей")
    let trainer2 = TrainerModel(id: UUID(), coachCode: "COACH002", userName: "Тренер Ольга")
    let trainer3 = TrainerModel(id: UUID(), coachCode: "COACH003", userName: "Тренер Дмитрий")
    let userTrainer = UserModel(id: trainer1.id, name: "Алексей", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Тренер Алексей", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 1)
    let currentUser = UserModel(id: UUID(uuidString: "123E4567-E89B-12D3-A456-426614174000")!, name: "Vadim", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let user = UserModel(id: UUID(), name: "vadim", avatar: "defuult", progress: progress, status: .outGym, email: "@", userName: "Vadim", phoneNumber: "898989898899", gender: .female, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let users: [UserModel] = [userTrainer, currentUser, user]
    let trainer: [TrainerModel] = [trainer1, trainer2, trainer3]
    
    let apiService = MockAPIService(users: users, trainer: trainer)
    let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let statsRepository = StatsRepository(apiService: apiService, dataService: dataService)
    
    let statsViewModel = StatsViewModel(repository: statsRepository, user: currentUser)
    let statsViewController = StatsViewController(viewModel: statsViewModel)
    let navigationController = UINavigationController(rootViewController: statsViewController)
    return navigationController

}

extension StatsViewController{
    internal func setupLevelRing() {
        view.addSubview(levelRingView)
        levelRingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            levelRingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelRingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            levelRingView.widthAnchor.constraint(equalToConstant: 100),
            levelRingView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    internal func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StatsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        

        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: levelRingView.bottomAnchor, constant: 200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: rewardButton.topAnchor, constant: -20) // таблица заканчивается за 20 пунктов выше кнопки
        ])
    }
    
    internal func setupRewardButton() {
        view.addSubview(rewardButton)
        rewardButton.setTitle("Награды", for: .normal)
        rewardButton.setTitleColor(.black, for: .normal)
        rewardButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        rewardButton.layer.cornerRadius = 10
        rewardButton.translatesAutoresizingMaskIntoConstraints = false
        rewardButton.addTarget(self, action: #selector(showRewards), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            rewardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            rewardButton.widthAnchor.constraint(equalToConstant: 200),
            rewardButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
