//
//  RegisterViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//
//
//  RegisterViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

import UIKit

#Preview {
    let rep = RegisterRepository()
    let viewController = RegisterViewModel(repository: rep)
    let controller = RegisterViewController(registerModel: viewController)
    let navigationController = UINavigationController(rootViewController: controller)
    return navigationController
}

class RegisterViewController: UIViewController {
    
    private let registerModel: RegisterViewModel
    
    init(registerModel: RegisterViewModel) {
        self.registerModel = registerModel
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
    private let birthDateTextField = UITextField()
    private let clubPicker = UIPickerView()
    private let genderSegmentControl = UISegmentedControl()
    private let statusSegmentControl = UISegmentedControl()
    private let coachCodeTextField = UITextField()
    private let registerButton = UIButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white  // фон экрана
        
        // Регистрируем уведомления о клавиатуре
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setupUI()
        setupDelegates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        // Настройка ScrollView и ContentView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
        scrollView.backgroundColor = .lightGray.withAlphaComponent(0.1)  // для отладки можно убрать
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Ограничения для scrollView относительно view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // Ограничения для contentView относительно scrollView
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)  // фиксированная ширина
        ])
        
        // Настройка полей ввода
        
        usernameTextField.placeholder = "Username"
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        confirmPasswordTextField.placeholder = "Confirm Password"
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        phoneTextField.placeholder = "Phone"
        phoneTextField.keyboardType = .phonePad
        phoneTextField.borderStyle = .roundedRect
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        
        birthDateTextField.placeholder = "Birth Date (DD/MM/YYYY)"
        birthDateTextField.borderStyle = .roundedRect
        birthDateTextField.translatesAutoresizingMaskIntoConstraints = false
        
        clubPicker.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка сегмент контролов
        
        genderSegmentControl.insertSegment(withTitle: "Male", at: 0, animated: false)
        genderSegmentControl.insertSegment(withTitle: "Female", at: 1, animated: false)
        genderSegmentControl.selectedSegmentIndex = 0
        genderSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        statusSegmentControl.insertSegment(withTitle: "Trainer", at: 0, animated: false)
        statusSegmentControl.insertSegment(withTitle: "Not a Trainer", at: 1, animated: false)
        statusSegmentControl.selectedSegmentIndex = 1
        statusSegmentControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Поле для кода тренера (скрыто по умолчанию)
        coachCodeTextField.placeholder = "Trainer Code"
        coachCodeTextField.borderStyle = .roundedRect
        coachCodeTextField.translatesAutoresizingMaskIntoConstraints = false
        coachCodeTextField.isHidden = true
        
        // Кнопка регистрации
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
        let views: [UIView] = [usernameTextField, emailTextField, passwordTextField, confirmPasswordTextField, phoneTextField, birthDateTextField, clubPicker, genderSegmentControl, statusSegmentControl, coachCodeTextField, registerButton]
        views.forEach { contentView.addSubview($0) }
        
        // AutoLayout для всех элементов (отступы по 15 пунктов между полями)
        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            usernameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            usernameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            emailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 15),
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
            
            clubPicker.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 15),
            clubPicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            clubPicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            clubPicker.heightAnchor.constraint(equalToConstant: 100),
            
            genderSegmentControl.topAnchor.constraint(equalTo: clubPicker.bottomAnchor, constant: 15),
            genderSegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            genderSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            statusSegmentControl.topAnchor.constraint(equalTo: genderSegmentControl.bottomAnchor, constant: 15),
            statusSegmentControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusSegmentControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            coachCodeTextField.topAnchor.constraint(equalTo: statusSegmentControl.bottomAnchor, constant: 15),
            coachCodeTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            coachCodeTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            coachCodeTextField.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: coachCodeTextField.bottomAnchor, constant: 30),
            registerButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 44),
            registerButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)  // чтобы задать общую высоту контента
        ])
        
        // Обработчик изменения статуса тренера
        statusSegmentControl.addTarget(self, action: #selector(statusChanged), for: .valueChanged)
    }
    
    private func setupDelegates() {
        // Если требуется обработка return и прочее
        usernameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        phoneTextField.delegate = self
        birthDateTextField.delegate = self
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
        // Если выбран статус "Trainer" (индекс 0), показываем поле для кода; иначе скрываем.
        coachCodeTextField.isHidden = statusSegmentControl.selectedSegmentIndex == 1
    }
    
    @objc private func registerButtonTapped() {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        let phone = phoneTextField.text
        let birthDate = birthDateTextField.text
        let gender = genderSegmentControl.selectedSegmentIndex == 0 ? "Male" : "Female"
        let status = statusSegmentControl.selectedSegmentIndex == 0 ? "Trainer" : "Not a Trainer"
        let coachCode = coachCodeTextField.text
        
        // Простейшая проверка на заполненность полей и совпадение паролей
        if let username = username, let email = email, let password = password, let confirmPassword = confirmPassword,
           !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty {
            if password == confirmPassword {
                // Здесь можно добавить логику регистрации, например, отправку данных на сервер
                print("Регистрация успешна")
            } else {
                showAlert(message: "Пароли не совпадают!")
            }
        } else {
            showAlert(message: "Заполните все поля!")
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
