//
//  StatsViewController+TableView.swift
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

extension StatsViewController: UITableViewDelegate{
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.currentStats.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            // Устанавливаем отступы между ячейками
            tableView.separatorInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)  // Добавляем отступ между ячейками
        }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            // Получаем ячейку
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath)
            
            // Делаем фон ячейки прозрачным
            cell.backgroundColor = .clear
            
            // Удаляем все ранее добавленные контейнеры (если ячейка переиспользуется)
            cell.contentView.subviews.forEach { $0.removeFromSuperview() }
            
            // Создаем контейнер, который будет внутри ячейки
            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0) // бежевый фон для контейнера
            container.layer.cornerRadius = 10
            container.clipsToBounds = true
            
            // Добавляем контейнер в contentView ячейки
            cell.contentView.addSubview(container)
            
            // Задаем отступы внутри ячейки — сверху и снизу, а также слева и справа
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 10),    // Верхний отступ
                container.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -10), // Нижний отступ
                container.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 10),
                container.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10)
            ])
            
            // Настраиваем содержимое контейнера (например, текст метки)
            // Если вы хотите использовать стандартную textLabel, можно добавить её внутрь контейнера:
            if indexPath.row < viewModel.currentStats.count {
                let stat = viewModel.currentStats[indexPath.row]
                // Создаем или настраиваем метку
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "\(stat.exerciseName) - Exp: \(stat.exp)"
                switch stat.status {
                case .confirmed:
                    label.textColor = .white
                case .inProgress:
                    label.textColor = .black
                case .awaitingConfirmation:
                    label.textColor = .black
                }
                
                container.addSubview(label)
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
                    label.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
                    label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -10)
                ])
            } else {
                // Если данных нет, можно добавить другую метку или оставить пустым
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.text = "Нет данных"
                label.textColor = .white
                container.addSubview(label)
                NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: container.centerYAnchor)
                ])
            }
            
            return cell
        }
}

