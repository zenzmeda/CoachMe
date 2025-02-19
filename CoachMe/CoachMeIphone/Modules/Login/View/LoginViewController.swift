//
//  LoginViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import UIKit
import Combine

#Preview {
    let users: [UserModel] = []
    let trainer: [TrainerModel] = []
    let apservice = MockAPIService(users: users, trainer: trainer)
    let dataservice = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let rep = RegisterRepository(apiService: apservice, dataService: dataservice)
    let viewcontroller = LoginViewModel(repository: rep)
    let controller = LoginViewController(loginModel: viewcontroller)
    let navigationController = UINavigationController(rootViewController: controller)
      navigationController
}

class LoginViewController: UIViewController {
    
    private let loginModel: LoginViewModel
    
    var cancellable: Set<AnyCancellable> = []
    
    var appNavigate : AppNavigator?
    
    init(loginModel: LoginViewModel, appNavigator: AppNavigator? = nil) {
        self.loginModel = loginModel
        self.appNavigate = appNavigator
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
        emailTextField.textContentType = .emailAddress
        emailTextField.placeholder = "username"
        emailTextField.borderStyle = .roundedRect  // Сделаем рамку у поля
        emailTextField.translatesAutoresizingMaskIntoConstraints = false  // Включаем AutoLayout
        passwordTextField.textContentType = .password
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
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)

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
        
       let statusAuthentication = loginModel.authentication(userName: email, password: password)
        statusAuthentication.sink(receiveCompletion:{ [weak self] completion in
            switch completion{
            case .finished:
                self?.showAlert(title: "SUCCESS", message: "Успешная авторизация")
            case .failure(let error):
                DispatchQueue.main.async{
                    switch error{
                    case .emptyFields:
                        self?.showAlert(title: "Error", message: "Заполните поля")
                    case .checkUserNameError:
                        self?.showAlert(title: "Error", message: "Пользователь не найден")
                    case .passwordDoNotMatch:
                        self?.showAlert(title: "Error", message: "Неверный пароль или имя")
                    default:
                        self?.showAlert(title: "Error", message: "Unknown error")
                    }
                }}}, receiveValue: { [weak self] user in
                    DispatchQueue.main.async{
                        self?.appNavigate?.currentUser = user
                        self?.goToMainTabBar()
                    }
            }).store(in: &cancellable)
    }
    
    private func showAlert(title: String, message: String, completion: ( ()->Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) {
            _ in completion?()
        }
        alert.addAction(okAction)
        present(alert, animated:  true)
    }
    
    private func goToMainTabBar () {
        appNavigate?.goToMainTabBar()
    }
    
    
}




