//
//  ProfileViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit
import Combine
// MARK: - Preview для Xcode
#Preview {
    let workout1 = Stats(exerciseName: "Отжимания", workingWeight: 10, repetitions: 1000, sets: 3, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Отжимания", repetitions: 2, sets: 2))
    let workout2 = Stats(exerciseName: "Подтягивания", workingWeight: 10, repetitions: 2, sets: 5, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Подтягивания", repetitions: 2, sets: 2))
    let workout3 = Stats(exerciseName: "Становая тяга", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .inProgress)
    let workout4 = Stats(exerciseName: "Приседания", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .awaitingConfirmation)
    let progress: [Stats] = [workout1, workout2, workout3, workout4]
        let trainer1 = TrainerModel(id: UUID(), coachCode: "COACH001", userName: "Тренер Алексей")
    let trainer2 = TrainerModel(id: UUID(), coachCode: "COACH002", userName: "Тренер Ольга")
    let trainer3 = TrainerModel(id: UUID(), coachCode: "COACH003", userName: "Тренер Дмитрий")
    let userTrainer = UserModel(id: trainer1.id, name: "Алексей", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Тренер Алексей", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 1)
    let currentUser = UserModel(id: UUID(), name: "Vadim", avatar: "default_avatar", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let user = UserModel(id: UUID(), name: "vadim", avatar: "defuult", progress: progress, status: .outGym, email: "@", userName: "Vadim", phoneNumber: "898989898899", gender: .female, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let users: [UserModel] = [userTrainer, currentUser, user]
    let trainer: [TrainerModel] = [trainer1, trainer2, trainer3]
    
    let apiService = MockAPIService(users: users, trainer: trainer)
    let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let userRepository = UserRepository(apiService: apiService, dataService: dataService)
    let userVM = ProfileViewModel(repository: userRepository, currentUser: currentUser)
    let userC = ProfileViewController(viewModel: userVM)
    let navigationController = UINavigationController(rootViewController: userC)
    return navigationController

}

class ProfileViewController: UIViewController, EditProfileDelegate {
    
  
    
    
    private let viewModel: ProfileViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ProfileViewModel) {
            self.viewModel = viewModel
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let statusLabel = UILabel()
    private let progressLabel = UILabel()
    private let ageLabel = UILabel()
    private let avatarContainerView = UIView()
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        setupUI()
        bindViewModel()
        title = "Профиль"
        
        let editButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editProfileTapped))
        navigationItem.rightBarButtonItem = editButton
    }
    
    private func bindViewModel() {
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                guard let self = self else { return }

                if isLoading {
                    self.loadingIndicator.startAnimating()
                    print("DATA NO SUCCESS \(self.viewModel.getUser().getAge())")
                } else {
                    self.loadingIndicator.stopAnimating()  // Скрываем индикатор
                    self.loadUserData()  // Обновляем UI, когда данные загружены
                    print("DATA IS LOADING SUCCESS")
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        view.addSubview(avatarContainerView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(progressLabel)
        view.addSubview(ageLabel)
        
        view.backgroundColor = .black
        
        let side: CGFloat = 100
            avatarContainerView.frame = CGRect(x: 20, y: 100, width: side, height: side)
            avatarContainerView.backgroundColor = .clear
            avatarContainerView.layer.cornerRadius = side / 2
            avatarContainerView.clipsToBounds = false  // Здесь отключаем обрезание, чтобы тень была видна
        
        // Настраиваем тень на контейнере
        avatarContainerView.layer.shadowColor = UIColor.white.cgColor
        avatarContainerView.layer.shadowOpacity = 0.6
        avatarContainerView.layer.shadowOffset = CGSize(width: 1, height: 1)
        avatarContainerView.layer.shadowRadius = 4
        
        // Добавляем imageView в контейнер
            avatarContainerView.addSubview(avatarImageView)

        
        // Настраиваем imageView
            avatarImageView.frame = avatarContainerView.bounds
            avatarImageView.contentMode = .scaleAspectFill
            avatarImageView.layer.cornerRadius = side / 2
            avatarImageView.clipsToBounds = true  // Здесь обрезаем изображение до круглой формы
        
        
        nameLabel.frame = CGRect(x: 20, y: 220, width: 300, height: 30)
        statusLabel.frame = CGRect(x: 20, y: 300, width: 300, height: 30)
        progressLabel.frame = CGRect(x: 20, y: 340, width: 300, height: 30)
        ageLabel.frame = CGRect(x:160 ,y:220,width: 300,height: 30)
    }
    
    // MARK: - Load User Data
    internal func loadUserData() {
        print("Началась загрузка экрана")
        do{
            try viewModel.fetchUser()
        }catch {
            print("Ошибка загрузки пользователя")
        }
        let currentUser = viewModel.getUser()
        let currentAvatar = currentUser.avatar
        if currentAvatar == "default_avatar"{
            avatarImageView.image = UIImage(named: currentAvatar)
        }else {
            avatarImageView.image = UIImage(data: Data(base64Encoded: currentAvatar) ?? Data())
        }
        
        nameLabel.text = currentUser.name
        nameLabel.textColor = .lightGray
        
        statusLabel.text = currentUser.status.rawValue
        statusLabel.textColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        
        progressLabel.text = String(currentUser.level)
        progressLabel.textColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        
        ageLabel.text = currentUser.getAge()
        ageLabel.textColor = .lightGray
        
        
    }
    
    
    
    // MARK: - Action for Editing (optional)
    @objc private func editProfileTapped() {
        let editViewModel = EditProfileViewModel(reposytory: viewModel.getRepository(), currentUser: viewModel.getUser())
        let editVC = EditProfileViewController(viewModel: editViewModel, delegate: self)
           navigationController?.pushViewController(editVC, animated: true)
       }
}
