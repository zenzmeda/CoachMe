//
//  StatsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit
import Combine

// MARK: - Preview для Xcode
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


class StatsViewController: UIViewController, UITableViewDataSource{
    internal let tableView = UITableView()
    internal let viewModel: StatsViewModel!
    internal let levelRingView = LevelRingView()
    internal let rewardButton = UIButton()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadStatsData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:{ [weak self] completion in
                switch completion {
                case .finished:
                    self?.bindViewModel()
                    print("Данные загружены.")
                case .failure(let error):
                    print("Ошибка загрузки данных: \(error)")
                    self?.bindViewModel()
                }
            }, receiveValue: { [weak self] _ in
                self?.updateLevelRing()
            }).store(in: &cancellables)
        
   
        
        view.backgroundColor = .black
        title = "Статистика"
        
        setupLevelRing()
        setupRewardButton()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.loadStatsData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:{ [weak self] completion in
                switch completion {
                case .finished:
                    self?.bindViewModel()
                    print("Данные загружены.")
                case .failure(let error):
                    print("Ошибка загрузки данных: \(error)")
                    self?.bindViewModel()
                }
            }, receiveValue: { [weak self] _ in
                self?.updateLevelRing()
            }).store(in: &cancellables)
        
        setupLevelRing()
        setupRewardButton()
        setupTableView()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLevelRing() // Проверяем, не изменился ли прогресс
    }
    
    private func updateLevelRing() {
        viewModel.loadStatsData()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Данные загружены успешно.")
                case .failure(let error):
                    print("Ошибка загрузки данных: \(error)")
                }
            }, receiveValue: { [weak self] _ in
                guard let self = self else { return }
                
                let currentExp = self.viewModel.getCurrentExp()
                let currentLevel = self.viewModel.getLevelSync()
                let maxExp = self.viewModel.experienceForLevel(level: currentLevel + 1)
                
                
                self.viewModel.getLevel()
                    .receive(on: DispatchQueue.main) // <--- Обновление на главном потоке
                    .sink(receiveCompletion: { completion in
                        switch completion {
                        case .finished:
                            print("Уровень успешно обновлен.")
                        case .failure(let error):
                            print("Ошибка level: \(error)")
                        }
                    }, receiveValue: { level in
                        self.levelRingView.setLevelLabel(level)
                    }).store(in: &self.cancellables)
                
                let progress = maxExp > 0 ? Float(currentExp) / Float(maxExp) : 0
                self.levelRingView.setProgress(progress)
                self.levelRingView.setNeedsDisplay()
                print("Progress: \(progress)")
            }).store(in: &cancellables)
    }

    
    @objc internal func showRewards() {
        let rewardsVC = RewardsViewController(level: viewModel.level)
        let navController = UINavigationController(rootViewController: rewardsVC)
        present(navController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$currentStats
            .receive(on: DispatchQueue.main)
            .sink { [weak self] stats in
                guard let self = self else { return }
                if stats.isEmpty {
                    self.showNoDataMessage()
                } else {
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showError(error)
                }
            }
            .store(in: &cancellables)
    }
    
  
    
   
}
