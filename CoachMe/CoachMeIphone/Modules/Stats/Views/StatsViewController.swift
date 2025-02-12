//
//  StatsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit

// MARK: - Preview для Xcode
#Preview {
    let dummyRepository = DummyStatsRepository() // Фейковый репозиторий для превью
    let dummyViewModel = StatsViewModel(repository: dummyRepository)
    let statsViewController = StatsViewController(viewModel: dummyViewModel)
    let navigationController = UINavigationController(rootViewController: statsViewController)
    return navigationController

}

class StatsViewController: UIViewController, UITableViewDataSource {
    private let tableView = UITableView()
    private let viewModel: StatsViewModel
    

    // Инициализация с инъекцией зависимости: передаем StatsViewModel
    init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    // Требуемый инициализатор для Storyboard (не используется, если создаем программно)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Статистика"
        setupTableView()
        
        setupAddButton()
        
        // Загружаем данные статистики через ViewModel
        viewModel.loadStatsData()
        tableView.reloadData()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "StatsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Применяем Auto Layout для tableView, чтобы он занимал весь экран
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupAddButton() {
           // Создаем кнопку для добавления упражнения
           let addButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addExercise))
           
           // Добавляем кнопку в правую часть navigation bar
           self.navigationItem.rightBarButtonItem = addButton
       }
    
    // Метод для обработки нажатия на кнопку
       @objc private func addExercise() {
           print("Добавить упражнение")
           
           // Например, можно показать диалог или новый экран для добавления упражнения
           // Пример вызова alert с полями для ввода данных:
           let alert = UIAlertController(title: "Добавить упражнение", message: "Введите данные для упражнения", preferredStyle: .alert)
           
           alert.addTextField { textField in
               textField.placeholder = "Название упражнения"
           }
           
           alert.addTextField { textField in
               textField.placeholder = "Вес (кг)"
               textField.keyboardType = .decimalPad
           }
           
           alert.addTextField { textField in
               textField.placeholder = "Повторения"
               textField.keyboardType = .numberPad
           }
           
           alert.addTextField { textField in
               textField.placeholder = "Сеты"
               textField.keyboardType = .numberPad
           }
           
           alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
           
           alert.addAction(UIAlertAction(title: "Сохранить", style: .default, handler: { _ in
               // Считываем данные из текстовых полей и добавляем новое упражнение
               if let exerciseName = alert.textFields?[0].text,
                  let workingWeight = Double(alert.textFields?[1].text ?? ""),
                  let repetitions = Int16(alert.textFields?[2].text ?? ""),
                  let sets = Int16(alert.textFields?[3].text ?? "") {
                   let newStats = Stats(exerciseName: exerciseName, workingWeight: workingWeight, repetitions: repetitions, sets: sets, date: Date())
                   self.viewModel.saveStat(newStats)
                   self.tableView.reloadData()
               }
           }))
           
           present(alert, animated: true)
       }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getRepository().fetchStats().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath)
        let stat = viewModel.getRepository().fetchStats()[indexPath.row]
        
        // Формируем текст с описанием статистики
        cell.textLabel?.text = "\(stat.exerciseName): \(stat.repetitions) reps, \(stat.sets) sets, \(stat.workingWeight)kg"
        return cell
    }

}
