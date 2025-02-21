//
//  WorkoutsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit
import Combine

#Preview {
    let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let progress: [Stats] = []
        let trainer1 = TrainerModel(id: UUID(), coachCode: "COACH001", userName: "Тренер Алексей")
    let trainer2 = TrainerModel(id: UUID(), coachCode: "COACH002", userName: "Тренер Ольга")
    let trainer3 = TrainerModel(id: UUID(), coachCode: "COACH003", userName: "Тренер Дмитрий")
    let userTrainer = UserModel(id: trainer1.id, name: "Алексей", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Тренер Алексей", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 1)
    let currentUser = UserModel(id: UUID(), name: "Vadim", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let user = UserModel(id: UUID(), name: "vadim", avatar: "defuult", progress: progress, status: .outGym, email: "@", userName: "Vadim", phoneNumber: "898989898899", gender: .female, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)

    let users : [UserModel] = [userTrainer, currentUser, user]
    let trainer : [TrainerModel] = [trainer1,trainer2,trainer3]
    
    let apiService = MockAPIService(users: users, trainer: trainer)
    let dummyRepository = WorkoutsRepository(dataService: dataService, apiService: apiService)
   
  
    let dummyViewModel = WorkoutsViewModel(repository: dummyRepository, user: currentUser)
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
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var cancellables: Set<AnyCancellable> = []
    
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
        viewModel.getStatusUserGYM()
        viewModel.$UserInGym
            .dropFirst()
            .sink(receiveValue: {[weak self] isInGym in
                if isInGym == UserModel.UserStatus.inGym{
                    self?.startButton.isEnabled = true
                }else {
                    self?.startButton.isEnabled = false
                    self?.showAlertForNotInGym()
                }}).store(in: &cancellables)
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
        startButton.isEnabled = false
        
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
        
        viewModel.fetchTrainers()
        
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        
        viewModel.$trainers
            .receive(on: DispatchQueue.main)
            .sink {[weak self] trainers in
                if !trainers.isEmpty{
                    self?.showTrainersAlert(trainers: trainers)
                    self?.swapFinishStartButtom()
                }else {
                    print("Список тренеров пока пуст, подождите...")
                }}.store(in: &cancellables)
    }
    
    func swapFinishStartButtom () {
        activityIndicator.stopAnimating()
        navigationItem.title = ""
        addExerciseButton.isHidden = true
        tableView.isHidden = true
        viewModel.clearCurrentWorkouts()
        startButton.isHidden = false
        finishButton.isHidden = true
        
    }
    
    @objc func addExerciseTapped() {
        let exerciseCategories: [String: [String]] = [
            "Грудь": ["Жим лёжа", "Отжимания", "Сведение рук"],
            "Ноги": ["Приседания", "Выпады", "Сгибание ног"],
            "Спина": ["Становая тяга", "Подтягивания", "Тяга блока"]
        ]
        
        let categoryAlert = UIAlertController(title: "Выберите категорию", message: nil, preferredStyle: .actionSheet)
        
        for (category, exercises) in exerciseCategories {
            let action = UIAlertAction(title: category, style: .default) { _ in
                self.showExercisesAlert(for: category, exercises: exercises)
            }
            categoryAlert.addAction(action)
        }
        
        categoryAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        present(categoryAlert, animated: true, completion: nil)
    }
    
    // Функция для отображения алерта, если пользователь не в клубе
    private func showAlertForNotInGym() {
        let alertController = UIAlertController(
            title: "Вы не в клубе",
            message: "Для того чтобы редактировать тренировки, необходимо быть в клубе.",
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alertController.addAction(action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    func showExercisesAlert(for category: String, exercises: [String]) {
        let exercisesAlert = UIAlertController(title: "Выберите упражнение", message: nil, preferredStyle: .actionSheet)

        for exercise in exercises {
            let action = UIAlertAction(title: exercise, style: .default) { _ in
                self.addExercise(name: exercise)
            }
            exercisesAlert.addAction(action)
        }

        exercisesAlert.addAction(UIAlertAction(title: "Назад", style: .cancel, handler: { _ in
            self.addExerciseTapped() // Вернуться к выбору категории
        }))

        present(exercisesAlert, animated: true, completion: nil)
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
        let newWorkout = Stats(exerciseName: name, workingWeight: 0, repetitions: 0, sets: 0, date: Date(),status: .inProgress)
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
        
        // Кнопка для сохранения изменений
        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { _ in
            guard let weightText = alert.textFields?[0].text,
                  let repetitionsText = alert.textFields?[1].text,
                  let setsText = alert.textFields?[2].text,
                  let newWeight = Int(weightText),
                  let newRepetitions = Int(repetitionsText),
                  let newSets = Int(setsText) else { return }
            
            // Обновляем тренировку в модели
            self.viewModel.updateWorkout(workout, newWeight: newWeight, newRepetitions: newRepetitions, newSets: newSets)
            
            // Обновляем таблицу
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        // Кнопка для удаления тренировки
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            
            // Удаляем тренировку из модели
            self.viewModel.deleteWorkout(workout)
            
            // Обновляем таблицу
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        // Кнопка для отмены
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        // Добавляем действия в алерт
        alert.addAction(saveAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        // Отображаем алерт
        present(alert, animated: true, completion: nil)
    }
    
    private func showTrainersAlert(trainers: [TrainerModel]) {
        let alert = UIAlertController(title: "Выберите тренера", message: nil, preferredStyle: .actionSheet)
        
        for trainer in trainers {
            let action = UIAlertAction(title: trainer.userName, style: .default) { _ in
                self.viewModel.sendWorkoutsForConfirmation(user: self.viewModel.getUser(), trainer: trainer)
                self.viewModel.mockConfirmation()
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

