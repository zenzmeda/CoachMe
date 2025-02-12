//
//  ProfileViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 07.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    
    private let viewModel: ProfileViewModel
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        setupUI()
        title = "Профиль"
        
        let editButton = UIBarButtonItem(title: "Редактировать", style: .plain, target: self, action: #selector(editProfileTapped))
        navigationItem.rightBarButtonItem = editButton
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
    private func loadUserData() {
        // В этом примере просто статичный аватар
        avatarImageView.image = UIImage(named: "default_avatar") // Подгрузим картинку из ресурсов (имя файла - default_avatar)
        
        nameLabel.text = "Vadim Timofeev"
        nameLabel.textColor = .lightGray
        
        statusLabel.text = "In Gym"
        statusLabel.textColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        
        progressLabel.text = "Progress: 5 workouts"
        progressLabel.textColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0)
        
        ageLabel.text = "Age: 27"
        ageLabel.textColor = .lightGray
        
        
    }
    
    
    
    // MARK: - Action for Editing (optional)
    @objc private func editProfileTapped() {
        let editViewModel = EditProfileViewModel(reposytory: viewModel.getRepository())
           let editVC = EditProfileViewController(viewModel: editViewModel)
           navigationController?.pushViewController(editVC, animated: true)
       }
}
