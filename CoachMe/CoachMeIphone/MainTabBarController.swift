//
//  MainTabBarController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//
import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let workoutR = WorkoutsRepository()
        let workoutsVM = WorkoutsViewModel(repository: workoutR)
        let workoutsVC = WorkoutsViewController(viewModel: workoutsVM)
        
        let statsR = StatsRepository()
        let statsVM = StatsViewModel(repository: statsR)
        let statsVC = StatsViewController(viewModel: statsVM)
        
        let profileR = UserRepository()
        let profileVM = ProfileViewModel(repository: profileR)
        let profileVC = ProfileViewController(viewModel: profileVM)

        workoutsVC.title = "Тренировки"
        statsVC.title = "Статистика"
        profileVC.title = "Профиль"

        workoutsVC.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(systemName: "list.bullet"), tag: 0)
        statsVC.tabBarItem = UITabBarItem(title: "Статистика", image: UIImage(systemName: "chart.bar"), tag: 1)
        profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 2)

        let nav1 = UINavigationController(rootViewController: workoutsVC)
        let nav2 = UINavigationController(rootViewController: statsVC)
        let nav3 = UINavigationController(rootViewController: profileVC)

        viewControllers = [nav1, nav2, nav3]
    }
}
