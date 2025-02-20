//
//  RewardCollectionViewCell.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 20.02.2025.
//

import UIKit

import UIKit

class RewardCollectionViewCell: UICollectionViewCell {
    
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        contentView.backgroundColor = .darkGray
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.isUserInteractionEnabled = true  // Обеспечивает возможность касания
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.clipsToBounds = true
        contentView.addSubview(iconImageView)
        
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        contentView.addSubview(nameLabel)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            nameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    func configure(with reward: Reward) {
        iconImageView.image = reward.icon
        nameLabel.text = reward.name
    }
}
