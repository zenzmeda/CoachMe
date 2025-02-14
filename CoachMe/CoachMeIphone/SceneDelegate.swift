//
//  SceneDelegate.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appNavigator: AppNavigator?  // Добавляем свойство для навигатора
    
    // MARK: - Scene Lifecycle
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Инициализируем окно
        window = UIWindow(windowScene: windowScene)
        
        let users : [UserModel] = []
        let trainer: [TrainerModel] = []
        let apiService = MockAPIService(users: users, trainer: trainer)
        let context = PersistenceManager.shared.context
        
        let registerRepository = RegisterRepository(apiService: apiService, dataService:UserLocalDataSource(context: context))
        let userRepository = UserRepository()
        let statsRepository = StatsRepository()
        let workoutsRepository = WorkoutsRepository()
        
        let registerVM = RegisterViewModel(repository: registerRepository)
        let loginVM = LoginViewModel(repository: registerRepository)
        let mainViewController = MainViewController(registerViewModel: registerVM, loginViewModel: loginVM)
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // Инициализируем AppNavigator и передаем в него окно
        appNavigator = AppNavigator(navigationController: navigationController,registerRepository: registerRepository, statsRepository: statsRepository, userReposytory: userRepository, workoutsRepository:workoutsRepository )
        
        window?.rootViewController = navigationController
           window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Сцена была отключена
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Сцена стала активной
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Сцена перестала быть активной
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Сцена вернулась из фона
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Сцена ушла в фон
    }
}
