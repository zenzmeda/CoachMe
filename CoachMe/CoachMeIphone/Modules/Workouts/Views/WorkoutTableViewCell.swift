//
//  WorkoutTableViewCell.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 20.02.2025.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    // Метки для отображения данных
    var exerciseNameLabel: UILabel!
    var workingWeightLabel: UILabel!
    var repetitionsLabel: UILabel!
    var setsLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        exerciseNameLabel = UILabel()
        exerciseNameLabel.backgroundColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 0.9)
        exerciseNameLabel.textColor = .black
        exerciseNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        exerciseNameLabel.textAlignment = .center
        exerciseNameLabel.layer.cornerRadius = 10
        exerciseNameLabel.layer.masksToBounds = true
        exerciseNameLabel.numberOfLines = 0 // Поддержка многострочного текста
        exerciseNameLabel.translatesAutoresizingMaskIntoConstraints = false
        exerciseNameLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)

        
        
        workingWeightLabel = UILabel()
        workingWeightLabel.backgroundColor = .black
        workingWeightLabel.textColor = .white
        workingWeightLabel.numberOfLines = 0
        workingWeightLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        repetitionsLabel = UILabel()
        repetitionsLabel.backgroundColor = .black
        repetitionsLabel.textColor = .white
        repetitionsLabel.numberOfLines = 0
        repetitionsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        setsLabel = UILabel()
        setsLabel.backgroundColor = .black
        setsLabel.textColor = .white
        setsLabel.numberOfLines = 0
        setsLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        // Настройка меток (например, добавление в супервью, установка шрифтов и т.д.)
        let stackView = UIStackView(arrangedSubviews: [exerciseNameLabel, workingWeightLabel, repetitionsLabel, setsLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)  // Добавляем отступы внутри StackView
        contentView.addSubview(stackView)
        
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



