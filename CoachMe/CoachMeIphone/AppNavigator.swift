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
        
        // Инициализация навигатора с переданным navigationController
        init(navigationController: UINavigationController,registerRepository: RegisterRepositoryProtocol,statsRepository: StatsRepositoryProtocol,userReposytory: UserReposytoryProtocol,workoutsRepository: WorkoutsRepositoryProtocol ) {
            self.navigationController = navigationController
            self.registerRepository = registerRepository
            self.statsRepository = statsRepository
            self.userReposytory = userReposytory
            self.workoutsRepository = workoutsRepository
        }
        
        // Переход на экран регистрации
        func goToRegistration() {
            print("Goreg вызван в AppNavigate")
            let registerVM = RegisterViewModel(repository: registerRepository)
            let registrationViewController = RegisterViewController(registerModel: registerVM,appNavigator: self)
            print("appNavigator in goToRegistration: \(String(describing: self))")
            navigationController.pushViewController(registrationViewController, animated: true)
        }
        
        // Переход на экран логина
        func goToLogin() {
            print("goToLogin() вызван в AppNavigator")
            let loginVM = LoginViewModel(repository: registerRepository)
            let loginViewController = LoginViewController(loginModel: loginVM)
            print("navigationController: \(navigationController)")
            navigationController.pushViewController(loginViewController, animated: true)
        }
        
        // Переход на главный таббар экран
        func goToMainTabBar() {
            let mainTabBarController = MainTabBarController()
            navigationController.pushViewController(mainTabBarController, animated: true)
        }
        
        // Переход на основной экран (MainViewController)
        func goToMainView() {
            let registerVM = RegisterViewModel(repository: registerRepository)
            let loginVM = LoginViewModel(repository: registerRepository)
            let mainViewController = MainViewController(registerViewModel: registerVM, loginViewModel: loginVM)
            navigationController.setViewControllers([mainViewController], animated: true)
        }
}
