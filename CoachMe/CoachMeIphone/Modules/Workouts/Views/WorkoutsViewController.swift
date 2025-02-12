//
//  WorkoutsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit

#Preview {
    let dummyRepository = WorkoutsRepository()
    let dummyViewModel = WorkoutsViewModel(repository: dummyRepository)
    let controller = WorkoutsViewController(viewModel: dummyViewModel)
    let navigationController = UINavigationController(rootViewController: controller)
    return navigationController
}

class WorkoutsViewController: UIViewController {
    private var viewModel: WorkoutsViewModel!
    var tableView: UITableView!
    var titleLabel: UILabel!
    var startButton: UIButton!
    var finishButton: UIButton!
    
    init(viewModel: WorkoutsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = ""  // Устанавливаем пустой титул в начале
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        // Настройка кнопки
        startButton = UIButton(type: .system)
        startButton.setTitle("Начать тренировку", for: .normal)
        startButton.setTitleColor(.black, for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        startButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 0.9)
        startButton.layer.cornerRadius = 100  // Чтобы кнопка стала круглой
        startButton.layer.masksToBounds = true
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.addTarget(self, action: #selector(startTrainingTapped), for: .touchUpInside)
        
        view.addSubview(startButton)
        
        // Настройки для кнопки
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),  // Ширина кнопки
            startButton.heightAnchor.constraint(equalToConstant: 200)   // Высота кнопки
        ])
        
        // Настройка кнопки "Завершить тренировку"
        finishButton = UIButton(type: .system)
        finishButton.setTitle("Завершить тренировку", for: .normal)
        finishButton.setTitleColor(.black, for: .normal)

        finishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        finishButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 0.9)

        finishButton.layer.cornerRadius = 50
        finishButton.layer.masksToBounds = true
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.addTarget(self, action: #selector(finishTrainingTapped), for: .touchUpInside)
        finishButton.isHidden = true  // Изначально скрыта
        
        view.addSubview(finishButton)
        
        // Настройки для кнопки "Завершить тренировку"
        NSLayoutConstraint.activate([
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            finishButton.widthAnchor.constraint(equalToConstant: 200),
            finishButton.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc func startTrainingTapped() {
        // Логика для начала тренировки
        print("Начинаем тренировку!")
        navigationItem.title = "Тренировки"
        setupTableView()
        // Скрываем кнопку "Начать тренировку"
        startButton.isHidden = true
        
        // Показываем кнопку "Завершить тренировку"
        finishButton.isHidden = false
    }
    
    @objc func finishTrainingTapped() {
        // Логика для завершения тренировки
        print("Завершаем тренировку!")
        
        // Сбрасываем титул
        navigationItem.title = ""
        
        // Скрываем таблицу
        tableView.isHidden = true
        
        // Показываем кнопку "Начать тренировку"
        startButton.isHidden = false
        
        // Скрываем кнопку "Завершить тренировку"
        finishButton.isHidden = true
    }
    
    private func setupTableView() {
        // Инициализируем таблицу вручную
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        // Регистрация кастомной ячейки
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: "WorkoutCell")
        
        // Настройки для таблицы (чтобы она не перекрывала заголовок)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = false  // Сначала показываем таблицу
        NSLayoutConstraint.activate([
                    tableView.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: -400),
                    tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    tableView.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -20)
                ])
    }
}

extension WorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workouts = viewModel.getRepository().fetchWorkouts()
        print("Workouts count: \(workouts.count)")  // Debugging
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workouts = viewModel.getRepository().fetchWorkouts()
        if workouts.isEmpty {
            print("Warning: No workouts available!")
        }
        
        // Извлечение кастомной ячейки
        let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutCell", for: indexPath) as! WorkoutTableViewCell
        
        // Получаем тренировку
        let workout = workouts[indexPath.row]
        
        // Устанавливаем текст для меток
        cell.exerciseNameLabel.text = workout.exerciseName
        cell.workingWeightLabel.text = "Вес: \(workout.workingWeight) кг"
        cell.repetitionsLabel.text = "Повторений: \(workout.repetitions)"
        cell.setsLabel.text = "Подходов: \(workout.sets)"
        
        return cell
    }
}

class WorkoutTableViewCell: UITableViewCell {
    // Метки для отображения данных
    var exerciseNameLabel: UILabel!
    var workingWeightLabel: UILabel!
    var repetitionsLabel: UILabel!
    var setsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Инициализируем метки
        exerciseNameLabel = UILabel()
        workingWeightLabel = UILabel()
        repetitionsLabel = UILabel()
        setsLabel = UILabel()
        
        // Настройка меток (например, добавление в супервью, установка шрифтов и т.д.)
        let stackView = UIStackView(arrangedSubviews: [exerciseNameLabel, workingWeightLabel, repetitionsLabel, setsLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        contentView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
