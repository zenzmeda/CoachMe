//
//  RegisterViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

import UIKit
import Combine
import SwiftUI

#Preview {
    let previewView: some View = {
        let trainer: [TrainerModel] = []
        let users: [UserModel] = []
        let apiService = MockAPIService(users: users, trainer: trainer)
        let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    
        let rep = RegisterRepository(apiService: apiService, dataService: dataService)
        let statR = StatsRepository(apiService: apiService, dataService: dataService)
        let userR = UserRepository()
        let workoutsR = WorkoutsRepository(dataService: dataService, apiService: apiService)
    
        let viewModel = RegisterViewModel(repository: rep)
        let controller = RegisterViewController(registerModel: viewModel)
        let navigationController = UINavigationController(rootViewController: controller)
    
        let appNavigator = AppNavigator(
            navigationController: navigationController,
            registerRepository: rep,
            statsRepository: statR,
            userReposytory: userR,
            workoutsRepository: workoutsR,
            window: nil // Для превью можно оставить nil
        )
    
        // Выполняем присваивание как побочный эффект
        controller.appNavigator = appNavigator
        
        // Возвращаем обёртку с navigationController
return  NavigationControllerPreview(navigationController: navigationController)
    }()
    
    previewView
}


class RegisterViewController: UIViewController {
    
    private let registerModel: RegisterViewModel
    
    private var cancellables: Set<AnyCancellable> = []
    
    var appNavigator: AppNavigator?
    
    init(registerModel: RegisterViewModel, appNavigator: AppNavigator? = nil) {
        self.registerModel = registerModel
        self.appNavigator = appNavigator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let usernameTextField = UITextField()
    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let confirmPasswordTextField = UITextField()
    private let phoneTextField = UITextField()
    private let nameTextField = UITextField()
    
    
    // Поле для даты рождения и UIDatePicker
    private let birthDateTextField = UITextField()
    private let birthDatePicker = UIDatePicker()
    
    // Для выбора пола – вместо UIPickerView используем кнопку с выпадающим меню
    private let genderButton = UIButton()
    private let genderOptions = ["Мужчина", "Женщина"]
    private var selectedGender: String?
    
    // UIPickerView для выбора клуба
    private let clubPicker = UIPickerView()
    let clubs = ["Tulskaya", "Shabolovka", "KrasnyiProspect"]
    
    // Контрол для статуса тренера (сегмент-контрол)
    private let statusSegmentControl = UISegmentedControl()
    private let coachCodeTextField = UITextField()
    private let registerButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupKeyboardNotifications()
        setupScrollViewAndContentView()
        setupUIElements()
        setupConstraints()
        setupDelegates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Functions
    
    private func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func setupScrollViewAndContentView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    private func setupUIElements() {
        // Настройка текстовых полей
        setupTextField(usernameTextField, placeholder: "Username")
        setupTextField(emailTextField, placeholder: "Email")
        setupTextField(passwordTextField, placeholder: "Password")
        setupTextField(confirmPasswordTextField, placeholder: "Confirm Password", isSecure: true)
        setupTextField(phoneTextField, placeholder: "Phone", keyboardType: .phonePad)
        setupTextField(nameTextField, placeholder: "Name")
        
        // Настройка поля и UIDatePicker для даты рождения
        setupBirthDateField()
        
        passwordTextField.textContentType = .none
        passwordTextField.isSecureTextEntry = true
        
        // Настройка UIPickerView для выбора клуба
        clubPicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка кнопки для выбора пола (выпадающий список)
        genderButton.translatesAutoresizingMaskIntoConstraints = false
        genderButton.setTitle("Select Gender", for: .normal)
        genderButton.setTitleColor(UIColor.gray.withAlphaComponent(0.5), for: .normal)
        genderButton.contentHorizontalAlignment = .left
        // Добавляем отступы для текста, чтобы он не прилегал вплотную к краю
        genderButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
        // Стилизация границы как у текстовых полей
        genderButton.layer.cornerRadius = 5
        genderButton.layer.borderWidth = 1
        genderButton.layer.borderColor = UIColor.lightGray.cgColor
        // Задаем белый фон, как у текстовых полей
        genderButton.backgroundColor = .white
        // Устанавливаем заголовок по умолчанию
        genderButton.setTitle("Select Gender", for: .normal)
        genderButton.setTitleColor(UIColor.gray.withAlphaComponent(0.5), for: .normal)
        
        //UIMenu с вариантами выбора пола (требуется iOS 14+)
        var genderActions: [UIAction] = []
        for option in genderOptions {
            let action = UIAction(title: option, handler: { [weak self] _ in
                self?.selectedGender = option
                self?.genderButton.setTitle(option, for: .normal)
            })
            genderActions.append(action)
        }
        genderButton.menu = UIMenu(title: "", children: genderActions)
        genderButton.showsMenuAsPrimaryAction = true
        // По умолчанию сохраняем первый вариант, если нужно
        selectedGender = genderOptions[0]
        
        // Настройка сегмент-контрола для выбора статуса тренера
        statusSegmentControl.insertSegment(withTitle: "Trainer", at: 0, animated: false)
        statusSegmentControl.insertSegment(withTitle: "Not a Trainer", at: 1, animated: false)
        statusSegmentControl.selectedSegmentIndex = 1
        statusSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка поля для кода тренера
        setupTextField(coachCodeTextField, placeholder: "Trainer Code")
        coachCodeTextField.isHidden = true
        
        // Настройка кнопки регистрации
        registerButton.setTitle("Register", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        registerButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        registerButton.layer.cornerRadius = 22
        registerButton.layer.masksToBounds = true
        registerButton.layer.shadowColor = UIColor.black.cgColor
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        registerButton.layer.shadowOpacity = 0.2
        registerButton.layer.shadowRadius = 4
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        // Добавляем все элементы в contentView
        let elements: [UIView] = [nameTextField, usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, phoneTextField, birthDateTextField, clubPicker, genderButton, statusSegmentControl, coachCodeTextField, registerButton]
        elements.forEach { contentView.addSubview($0) }
        
        // Добавляем обработчик для изменения статуса тренера
        statusSegmentControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
    }
    
    private func setupTextField(_ textField: UITextField, placeholder: String, isSecure: Bool = false, keyboardType: UIKeyboardType = .default) {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = isSecure
        textField.keyboardType = keyboardType
    }
    
    private func setupBirthDateField() {
        // Настройка текстового поля для даты рождения
        birthDateTextField.placeholder = "Birth Date"
        birthDateTextField.borderStyle = .roundedRect
        birthDateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка UIDatePicker
        birthDatePicker.datePickerMode = .date
        birthDatePicker.preferredDatePickerStyle = .wheels
        birthDatePicker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        // Используем UIDatePicker как inputView для текстового поля
        birthDateTextField.inputView = birthDatePicker
        // Добавляем тулбар с кнопкой "Готово"
        birthDateTextField.inputAccessoryView = createToolbar()
    }
    
    private func setupConstraints() {
        // Ограничения для scrollView и contentView
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // Ограничения для элементов внутри contentView
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            nameTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 15),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            phoneTextField.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 15),
            phoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneTextField.heightAnchor.constraint(equalToConstant: 44),
            
            birthDateTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15),
            birthDateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthDateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 44),
            
            clubPicker.topAnchor.constraint(equalTo: coachCodeTextField.bottomAnchor, constant: -10),
            clubPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            clubPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clubPicker.heightAnchor.constraint(equalToConstant: 100),
            
            genderButton.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 15),
            genderButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            genderButton.heightAnchor.constraint(equalToConstant: 44),
            
            statusSegmentControl.topAnchor.constraint(equalTo: genderButton.bottomAnchor, constant: 15),
            statusSegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            coachCodeTextField.topAnchor.constraint(equalTo: statusSegmentControl.bottomAnchor, constant: 15),
            coachCodeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coachCodeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coachCodeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: clubPicker.bottomAnchor, constant: 10),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupDelegates() {
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        phoneTextField.delegate = self
        
        clubPicker.dataSource = self
        clubPicker.delegate = self
    }
    
    // MARK: - Toolbar and DatePicker Actions
    
    private func createToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                         target: self,
                                         action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: false)
        return toolbar
    }
    
    @objc private func doneButtonTapped() {
        view.endEditing(true)
    }
    
    @objc private func datePickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        let selectedDate = dateFormatter.string(from: sender.date)
        birthDateTextField.text = selectedDate
    }
    
    // MARK: - Keyboard Notifications
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            scrollView.contentInset.bottom = keyboardFrame.height
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Actions
    
    @objc private func statusChanged() {
        // Если выбран статус "Trainer" (индекс 0), показываем поле для кода тренера, иначе скрываем.
        coachCodeTextField.isHidden = statusSegmentControl.selectedSegmentIndex == 1
    }
    
    @objc private func registerButtonTapped() {
        let selectedClubIndex = clubPicker.selectedRow(inComponent: 0)
        let selectedClub = clubs[selectedClubIndex]
        let currentStatusPublisher = registerModel.validateFields(
            name: nameTextField.text,
            userName: usernameTextField.text,
            email: emailTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text,
            phone: phoneTextField.text,
            birthDate: birthDateTextField.text,
            gender: selectedGender ?? "",
            status: statusSegmentControl.selectedSegmentIndex == 0 ? RegisterViewModel.StatusUserTrainer.trainer.rawValue : RegisterViewModel.StatusUserTrainer.notATrainer.rawValue,
            coachCode: coachCodeTextField.text,
            gym: selectedClub
        )

        // Подписка на результат
        currentStatusPublisher
            .sink(receiveValue: { [weak self] status in
                guard let self = self else { return }
                switch status {
                case .userExist:
                    self.showAlert(title: "Ошибка", message: "Пользователь уже существует")
                case .emptyFields:
                    self.showAlert(title: "Ошибка", message: "Заполните все поля")
                    self.highlightEmptyFields()
                case .errorCreate:
                    self.showAlert(title: "Ошибка", message: "Не удалось создать пользователя. Попробуйте позже.")
                case .userCreate:
                    self.showAlert(title: "Успех", message: "Регистрация успешна") { [weak self] in
                        self?.goToLogin()
                    }
                case .incorrectCoachCode:
                    self.showAlert(title: "Ошибка", message: "Неправильный код тренера")
                case .errorRegisterTrainer:
                    self.showAlert(title: "Ошибка", message: "Ошибка регистрации тренера")
                case .absentCoachCode:
                    self.showAlert(title: "Ошибка", message: "Не указан код тренера")
                case .ErrorFormatBirthDate:
                    self.showAlert(title: "Ошибка", message: "Неправильный формат даты рождения")
                case .IncorrectEmail:
                    self.showAlert(title: "Ошибка", message: "Некорректный email")
                case .passwordMismatch:
                    self.showAlert(title: "Ошибка", message: "Пароли не совпадают")
                case .IncorrectPhoneNumber:
                    self.showAlert(title: "Ошибка", message: "Некорректный номер телефона")
                case .errorCreateGYM:
                    self.showAlert(title: "Ошибка", message: "Ошибка создания клуба")
                }
            })
            .store(in: &cancellables)  // Сохраняем подписку для управления жизненным циклом
    }

    // Теперь showAlert принимает completion для обработки нажатия "OK"
    private func showAlert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func highlightEmptyFields() {
        let fields: [(UITextField, String?)] = [
            (nameTextField, nameTextField.text),
            (usernameTextField, usernameTextField.text),
            (emailTextField, emailTextField.text),
            (passwordTextField, passwordTextField.text),
            (confirmPasswordTextField, confirmPasswordTextField.text),
            (phoneTextField, phoneTextField.text),
            (birthDateTextField, birthDateTextField.text)
        ]
        
        for (field, text) in fields {
            if text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true {
                field.layer.borderColor = UIColor.red.cgColor
                field.layer.borderWidth = 1.0
            } else {
                field.layer.borderColor = UIColor.clear.cgColor
                field.layer.borderWidth = 0.0
            }
        }
    }
    
    func goToLogin() {
        print("appNavigate перед вызовом: \(String(describing: appNavigator))")
        print("Go to LoGIN from Registration")
        appNavigator?.goToLogin()
        }
}


// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UIPickerViewDataSource & UIPickerViewDelegate

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  // Один столбец
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == clubPicker {
            return clubs.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == clubPicker {
            return clubs[row]
        }
        return nil
    }
}
