//
//  RewardDetailViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 20.02.2025.
//

import UIKit

import UIKit

class RewardDetailViewController: UIViewController {
    
    private let reward: Reward
    private let rewardImageView = UIImageView()
    private let rewardDescriptionLabel = UILabel()
    
    init(reward: Reward) {
        self.reward = reward
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = reward.name
        setupUI()
    }
    
    private func setupUI() {
        rewardImageView.image = reward.icon
        rewardImageView.contentMode = .scaleAspectFit
        rewardImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rewardImageView)
        
        rewardDescriptionLabel.text = reward.description
        rewardDescriptionLabel.numberOfLines = 0
        rewardDescriptionLabel.textColor = .black
        rewardDescriptionLabel.textAlignment = .center
        rewardDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rewardDescriptionLabel)
        
        NSLayoutConstraint.activate([
            rewardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rewardImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            rewardImageView.widthAnchor.constraint(equalToConstant: 150),
            rewardImageView.heightAnchor.constraint(equalToConstant: 150),
            
            rewardDescriptionLabel.topAnchor.constraint(equalTo: rewardImageView.bottomAnchor, constant: 20),
            rewardDescriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            rewardDescriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
