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
    let currentUser = UserModel(id: UUID(), name: "Vadim", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
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


class StatsViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private let viewModel: StatsViewModel
    private let levelRingView = LevelRingView()
    private let rewardButton = UIButton()
    
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
        bindViewModel()
        
        view.backgroundColor = .black
        title = "Статистика"
        
        setupLevelRing()
        setupTableView()
        setupRewardButton()
        
        // Ждём загрузки данных перед обновлением LevelRing
        viewModel.loadStatsData()
            .receive(on: DispatchQueue.main)  // Обновляем UI на главном потоке
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Данные загружены.")
                case .failure(let error):
                    print("Ошибка загрузки данных: \(error)")
                }
            }, receiveValue: { [weak self] _ in
                self?.updateLevelRing() // Обновляем LevelRing только после загрузки
            }).store(in: &cancellables)
    }

    
    private func setupLevelRing() {
        view.addSubview(levelRingView)
        levelRingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            levelRingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelRingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            levelRingView.widthAnchor.constraint(equalToConstant: 100),
            levelRingView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLevelRing() // Проверяем, не изменился ли прогресс
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .black
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StatsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: levelRingView.bottomAnchor, constant: 200),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRewardButton() {
        view.addSubview(rewardButton)
        rewardButton.setTitle("Награды", for: .normal)
        rewardButton.setTitleColor(.black, for: .normal)
        rewardButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        rewardButton.layer.cornerRadius = 10
        rewardButton.translatesAutoresizingMaskIntoConstraints = false
        rewardButton.addTarget(self, action: #selector(showRewards), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            rewardButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -150),
            rewardButton.widthAnchor.constraint(equalToConstant: 200),
            rewardButton.heightAnchor.constraint(equalToConstant: 40)
        ])
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
                
                print("CurrentExp: \(currentExp) MAX: \(maxExp)")
                
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

    
    @objc private func showRewards() {
        let rewardsVC = RewardsViewController(level: viewModel.level)
        let navController = UINavigationController(rootViewController: rewardsVC)
        present(navController, animated: true)
    }
    
    private func bindViewModel() {
        viewModel.$currentStats
            .receive(on: DispatchQueue.main)
            .sink {[weak self] _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                guard let self = self else { return }
                                if self.viewModel.currentStats.isEmpty {
                                    self.showNoDataMessage()
                                } else {
                                    self.tableView.reloadData()
                                }
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
    
    private func showError(_ error: Error) {
        let message = error.localizedDescription.isEmpty ? "Неизвестная ошибка" : error.localizedDescription
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    private func showNoDataMessage() {
        let alert = UIAlertController(title: "Нет данных", message: "Для отображения статистики требуется больше информации.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentStats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath)
        if indexPath.row < viewModel.currentStats.count {
            cell.textLabel?.text = "\(viewModel.currentStats[indexPath.row].exerciseName) - Exp: \(viewModel.currentStats[indexPath.row].exp)"
            switch viewModel.currentStats[indexPath.row].status {
                   case .confirmed:
                cell.textLabel?.textColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0) // бежевый цвет
            case .inProgress:
                       cell.textLabel?.textColor = .orange
            case .awaitingConfirmation:
                       cell.textLabel?.textColor = .red
                   }
          } else {
              cell.textLabel?.text = "Нет данных" // Иначе отображаем дефолтный текст
              cell.textLabel?.textColor = .white
          }
        cell.backgroundColor = .black
        return cell
    }
}
