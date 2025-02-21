//
//  AppNAvigator.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 14.02.2025.
//
import UIKit

class AppNavigator{
    // Ссылка на navigationController
        private var navigationController: UINavigationController
    private let registerRepository: RegisterRepositoryProtocol
    private let statsRepository: StatsRepositoryProtocol
    private let userReposytory: UserReposytoryProtocol
    private let workoutsRepository: WorkoutsRepositoryProtocol
    private let window: UIWindow?
    var currentUser: UserModel?
        
        // Инициализация навигатора с переданным navigationController
    init(navigationController: UINavigationController,registerRepository: RegisterRepositoryProtocol,statsRepository: StatsRepositoryProtocol,userReposytory: UserReposytoryProtocol,workoutsRepository: WorkoutsRepositoryProtocol, window: UIWindow? = nil ) {
        self.navigationController = navigationController
        self.registerRepository = registerRepository
        self.statsRepository = statsRepository
        self.userReposytory = userReposytory
        self.workoutsRepository = workoutsRepository
        self.window = window
    }
        
        // Переход на экран регистрации
        func goToRegistration() {
            let registerVM = RegisterViewModel(repository: registerRepository)
            let registrationViewController = RegisterViewController(registerModel: registerVM,appNavigator: self)
            navigationController.pushViewController(registrationViewController, animated: true)
        }
        
        // Переход на экран логина
        func goToLogin() {
            let loginVM = LoginViewModel(repository: registerRepository)
            let loginViewController = LoginViewController(loginModel: loginVM, appNavigator: self)
            navigationController.pushViewController(loginViewController, animated: true)
        }
        
        // Переход на главный таббар экран
    func goToMainTabBar() {
            guard let window = window else { return }
        guard let currentUser = currentUser else {return}
        let mainTabBarController = MainTabBarController(currentUser: currentUser, repositoryWorkout: workoutsRepository, repositoryToStats: statsRepository, repositoryToUser: userReposytory)
                    window.rootViewController = mainTabBarController
                    window.makeKeyAndVisible()
        }
        
        // Переход на основной экран (MainViewController)
        func goToMainView() {
            let registerVM = RegisterViewModel(repository: registerRepository)
            let loginVM = LoginViewModel(repository: registerRepository)
            let mainViewController = MainViewController(registerViewModel: registerVM, loginViewModel: loginVM)
            navigationController.setViewControllers([mainViewController], animated: true)
        }
}
