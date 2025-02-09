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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        setupUI()
        view.backgroundColor = .white
        title = "Профиль"
    }
    
    private func setupUI() {
        view.addSubview(avatarImageView)
        view.addSubview(nameLabel)
        view.addSubview(statusLabel)
        view.addSubview(progressLabel)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 50 // Радиус для округления
        avatarImageView.clipsToBounds = true
        // Установим фрейм или используем Auto Layout
        avatarImageView.frame = CGRect(x: 20, y: 100, width: 100, height: 100)
        
        nameLabel.frame = CGRect(x: 20, y: 220, width: 300, height: 30)
        statusLabel.frame = CGRect(x: 20, y: 260, width: 300, height: 30)
        progressLabel.frame = CGRect(x: 20, y: 300, width: 300, height: 30)
    }
    
    // MARK: - Load User Data
    private func loadUserData() {
        // В этом примере просто статичный аватар
        avatarImageView.image = UIImage(named: "default_avatar") // Подгрузим картинку из ресурсов (имя файла - default_avatar)
        
        nameLabel.text = "Vadim Timofeev"
        statusLabel.text = "In Gym"
        progressLabel.text = "Progress: 5 workouts"
        
        
    }
    
    // MARK: - Action for Editing (optional)
        @objc private func editProfileTapped() {
            // Открыть экран редактирования профиля
        }
}
