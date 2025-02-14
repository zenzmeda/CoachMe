//
//  SceneDelegate.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

        // MARK: - Scene Lifecycle
        func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
            guard let windowScene = (scene as? UIWindowScene) else { return }
            print("HERe")
            // Создаем окно и назначаем его для текущей сцены
            let users: [UserModel] = []
            let trainer: [TrainerModel] = []
            let apiService = MockAPIService(users: users, trainer: trainer)
            let dataService = UserLocalDataSource(context: PersistenceManager.shared.context)
            let rep = RegisterRepository(apiService: apiService, dataService: dataService)
                let registerViewModel = RegisterViewModel(repository: rep)
                let registerVC = RegisterViewController(registerModel: registerViewModel)
                
                // Создаем окно
                window = UIWindow(windowScene: windowScene)
                window?.rootViewController = registerVC  // Устанавливаем контроллер регистрации
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
