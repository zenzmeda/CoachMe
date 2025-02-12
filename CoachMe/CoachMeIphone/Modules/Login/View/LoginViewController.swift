//
//  LoginViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import UIKit

#Preview {
    let rep = RegisterRepository()
    let viewcontroller = LoginViewModel(repository: rep)
    let controller = LoginViewController(loginModel: viewcontroller)
    let navigationController = UINavigationController(rootViewController: controller)
      navigationController
}

class LoginViewController: UIViewController {
    
    private let loginModel: LoginViewModel
    
    init(loginModel: LoginViewModel) {
        self.loginModel = loginModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let registerButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Настроим поля для ввода email и пароля
        emailTextField.placeholder = "Email or username"
        emailTextField.borderStyle = .roundedRect  // Сделаем рамку у поля
        emailTextField.translatesAutoresizingMaskIntoConstraints = false  // Включаем AutoLayout

        passwordTextField.placeholder = "Password"
        passwordTextField.isSecureTextEntry = true  // Скрытые символы для пароля
        passwordTextField.borderStyle = .roundedRect  // Рамка у поля
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false  // Включаем AutoLayout
        
        // Настроим кнопку регистрации
        registerButton.setTitle("Login", for: .normal)
        registerButton.setTitleColor(.white, for: .normal)  // Белый цвет текста
        registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)  // Жирный шрифт
        registerButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)  // Светло-коричневый
        registerButton.layer.cornerRadius = 22  // Радиус закругления углов
        registerButton.layer.masksToBounds = true  // Применить закругления
        registerButton.layer.shadowColor = UIColor.black.cgColor  // Цвет тени
        registerButton.layer.shadowOffset = CGSize(width: 0, height: 2)  // Смещение тени
        registerButton.layer.shadowOpacity = 0.2  // Прозрачность тени
        registerButton.layer.shadowRadius = 4  // Радиус размытия тени
        registerButton.translatesAutoresizingMaskIntoConstraints = false  // Включаем AutoLayout

        // Добавляем элементы на экран
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        // Настроим AutoLayout для полей и кнопки
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            registerButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            registerButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }



    @objc private func registerButtonTapped() {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        // Обработка входа
        if let email = email, let password = password, !email.isEmpty, !password.isEmpty {
        }
    }
}




