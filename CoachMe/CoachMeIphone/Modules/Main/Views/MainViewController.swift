//
//  MainViews.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 12.02.2025.
//

import UIKit
import CoreData

#Preview {
    let users: [UserModel] = []
    let trainer: [TrainerModel] = []
    let context = UserLocalDataSource.createTestContext()
    let dataService = UserLocalDataSource(context: context)
    let api = MockAPIService(users: users, trainer: trainer)
    let rep = RegisterRepository(apiService: api, dataService: dataService)
    let viewcontroller = RegisterViewModel(repository: rep)
    let logVM = LoginViewModel(repository: rep)
    let controller = MainViewController(registerViewModel: viewcontroller, loginViewModel: logVM)
    let navigationController = UINavigationController(rootViewController: controller)
      navigationController
}

class MainViewController: UIViewController {
    
    private let registerViewModel: RegisterViewModel
    private let loginViewModel: LoginViewModel
    
    var appNavigate: AppNavigator?
    
    init(registerViewModel: RegisterViewModel, loginViewModel: LoginViewModel, appNavigate: AppNavigator? = nil) {
        self.registerViewModel = registerViewModel
        self.loginViewModel = loginViewModel
        self.appNavigate = appNavigate
        super.init(nibName: nil, bundle: nil)
    }
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
  

    private let registerButton = UIButton()
    private let loginButton = UIButton()
    
    
    
  
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("appNavigate в MainViewController: \(String(describing: appNavigate))")
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .black
        
        
        
        // Настройка кнопки "Регистрация"
        registerButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0) // Бежевый
        registerButton.layer.cornerRadius = 20
        registerButton.setTitle("Регистрация", for: .normal)
        registerButton.setTitleColor(.black, for: .normal)
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Настройка кнопки "Войти"
        loginButton.setTitle("Войти", for: .normal)
        loginButton.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.layer.cornerRadius = 20
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(registerButton)
        view.addSubview(loginButton)
        view.addSubview(logoImageView)
        
        // Настроим расположение кнопок с помощью Auto Layout
        NSLayoutConstraint.activate([
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            registerButton.widthAnchor.constraint(equalToConstant: 200),
            registerButton.heightAnchor.constraint(equalToConstant: 40),
            registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            registerButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
            loginButton.topAnchor.constraint(equalTo: registerButton.bottomAnchor, constant: 20)
        ])
    }

    @objc private func registerButtonTapped() {
        appNavigate?.goToRegistration()
    }

    @objc private func loginButtonTapped() {
        appNavigate?.goToLogin()
    }
}
