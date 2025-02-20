//
//  MainTabBarController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    private let currentUser: UserModel
    private let repositoryToWorkout: WorkoutsRepositoryProtocol
    private let repositoryToStats: StatsRepositoryProtocol
    
    init(currentUser: UserModel, repositoryWorkout: WorkoutsRepositoryProtocol, repositoryToStats: StatsRepositoryProtocol) {
        self.currentUser = currentUser
        self.repositoryToWorkout = repositoryWorkout
        self.repositoryToStats = repositoryToStats
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let workoutsVM = WorkoutsViewModel(repository: repositoryToWorkout, user: currentUser)
        let workoutsVC = WorkoutsViewController(viewModel: workoutsVM)
        
        let statsVM = StatsViewModel(repository: repositoryToStats, user: currentUser)
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
