//
//  WorkoutsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit

#Preview {
    let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let users : [UserModel] = []
    let trainer : [TrainerModel] = []
    let apiService = MockAPIService(users: users, trainer: trainer)
    let dummyRepository = WorkoutsRepository(dataService: dataService, apiService: apiService)
    let dummyViewModel = WorkoutsViewModel(repository: dummyRepository)
    let controller = WorkoutsViewController(viewModel: dummyViewModel)
    let navigationController = UINavigationController(rootViewController: controller)
    navigationController
}

class WorkoutsViewController: UIViewController {
    private var viewModel: WorkoutsViewModel!
    var tableView: UITableView!
    var titleLabel: UILabel!
    var startButton: UIButton!
    var finishButton: UIButton!
    var addExerciseButton: UIButton!
    
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
        
        let addExerciseButton = UIButton(type: .system)
            addExerciseButton.setTitle("Добавить упражнение", for: .normal)
            addExerciseButton.setTitleColor(.black, for: .normal)
            addExerciseButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            addExerciseButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 0.9)
            addExerciseButton.layer.cornerRadius = 10
            addExerciseButton.translatesAutoresizingMaskIntoConstraints = false
            addExerciseButton.addTarget(self, action: #selector(addExerciseTapped), for: .touchUpInside)
            addExerciseButton.isHidden = true // Показываем только во время тренировки
        
        view.addSubview(addExerciseButton)
        
        self.addExerciseButton = addExerciseButton
    
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
        NSLayoutConstraint.activate([
            addExerciseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addExerciseButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20), // Отступ от верхней части экрана
            addExerciseButton.widthAnchor.constraint(equalToConstant: 200),
            addExerciseButton.heightAnchor.constraint(equalToConstant: 50)
        ])

        

    }
    
    @objc func startTrainingTapped() {
        print("Начинаем тренировку!")
        navigationItem.title = "Тренировки"
        setupTableView()
        startButton.isHidden = true
        addExerciseButton.isHidden = false
        finishButton.isHidden = false

        // Поднимаем кнопку «Добавить упражнение» поверх всех остальных элементов
        view.bringSubviewToFront(addExerciseButton)
    }
    
    @objc func finishTrainingTapped() {
        // Логика для завершения тренировки
        print("Завершаем тренировку!")
        
        // Сбрасываем титул
        navigationItem.title = ""
        
        // Скрываем таблицу
        tableView.isHidden = true
        
        addExerciseButton.isHidden = true
        viewModel.clearCurrentWorkouts()
        tableView.reloadData()
        
        // Показываем кнопку "Начать тренировку"
        startButton.isHidden = false
        
        // Скрываем кнопку "Завершить тренировку"
        finishButton.isHidden = true
    }
    
    @objc func addExerciseTapped() {
        let availableExercises = ["Жим лёжа", "Приседания", "Становая тяга", "Подтягивания", "Отжимания"]
        
        let alert = UIAlertController(title: "Выберите упражнение", message: nil, preferredStyle: .actionSheet)
        
        for exercise in availableExercises {
            let action = UIAlertAction(title: exercise, style: .default) { _ in
                self.addExercise(name: exercise)
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func setupTableView() {
        // Инициализируем таблицу вручную
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .black
        view.addSubview(tableView)
        
        // Регистрация кастомной ячейки
        tableView.register(WorkoutTableViewCell.self, forCellReuseIdentifier: "WorkoutCell")
        
        // Настройки для таблицы (чтобы она не перекрывала заголовок)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = false  // Сначала показываем таблицу
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: addExerciseButton.bottomAnchor, constant: 20), // Отступ от кнопки
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -20)
        ])
    }
    
    private func addExercise(name: String) {
        let newWorkout = Stats(exerciseName: name, workingWeight: 0, repetitions: 0, sets: 0, date: Date())
        viewModel.addWorkoutToCurrentWokkout(newWorkout)
        tableView.reloadData()
    }
}

extension WorkoutsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workouts = viewModel.getCurrentWorckout()
        print("Workouts count: \(workouts.count)")  // Debugging
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workouts = viewModel.getCurrentWorckout()
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
        
        cell.backgroundColor = .black
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCellTap(_:)))
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func handleCellTap(_ sender: UITapGestureRecognizer) {
        if let cell = sender.view as? WorkoutTableViewCell {
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            let workout = viewModel.getCurrentWorckout()[indexPath.row]
            showEditWorkoutAlert(workout: workout, indexPath: indexPath)
        }
    }
    private func showEditWorkoutAlert(workout: Stats, indexPath: IndexPath) {
        let alert = UIAlertController(title: "Редактировать тренировку", message: nil, preferredStyle: .alert)
        
        // Поля для ввода нового веса, повторений и подходов
        alert.addTextField { textField in
            textField.text = "\(workout.workingWeight)"
            textField.keyboardType = .numberPad
            textField.placeholder = "Вес (кг)"
        }
        alert.addTextField { textField in
            textField.text = "\(workout.repetitions)"
            textField.keyboardType = .numberPad
            textField.placeholder = "Повторений"
        }
        alert.addTextField { textField in
            textField.text = "\(workout.sets)"
            textField.keyboardType = .numberPad
            textField.placeholder = "Подходов"
        }
        
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let weightText = alert.textFields?[0].text,
                  let repetitionsText = alert.textFields?[1].text,
                  let setsText = alert.textFields?[2].text,
                  let newWeight = Int(weightText),
                  let newRepetitions = Int(repetitionsText),
                  let newSets = Int(setsText) else { return }
            
            // Обновляем тренировку в модели
            self.viewModel.updateWorkout(workout, newWeight: newWeight, newRepetitions: newRepetitions, newSets: newSets)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
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
        
        exerciseNameLabel = UILabel()
        exerciseNameLabel.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 0.9)
        exerciseNameLabel.textColor = .black
        exerciseNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        exerciseNameLabel.textAlignment = .center
        exerciseNameLabel.layer.cornerRadius = 10
        exerciseNameLabel.layer.masksToBounds = true
        exerciseNameLabel.numberOfLines = 0 // Поддержка многострочного текста
        exerciseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        
        
        workingWeightLabel = UILabel()
        workingWeightLabel.backgroundColor = .black
        workingWeightLabel.textColor = .white
        workingWeightLabel.numberOfLines = 0
        workingWeightLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        repetitionsLabel = UILabel()
        repetitionsLabel.backgroundColor = .black
        repetitionsLabel.textColor = .white
        repetitionsLabel.numberOfLines = 0
        repetitionsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        setsLabel = UILabel()
        setsLabel.backgroundColor = .black
        setsLabel.textColor = .white
        setsLabel.numberOfLines = 0
        setsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        // Настройка меток (например, добавление в супервью, установка шрифтов и т.д.)
        let stackView = UIStackView(arrangedSubviews: [exerciseNameLabel, workingWeightLabel, repetitionsLabel, setsLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)  // Добавляем отступы внутри StackView
        contentView.addSubview(stackView)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



