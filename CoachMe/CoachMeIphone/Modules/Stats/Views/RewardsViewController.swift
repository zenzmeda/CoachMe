//
//  RewardsViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 20.02.2025.
//
import UIKit

struct Reward {
    let name: String
    let icon: UIImage
    let description: String
}

class RewardsViewController: UIViewController {
    
    private var level: Int
    private let rewardsCollectionView: UICollectionView
    private var rewards: [Reward] = []  // Массив наград
    
    init(level: Int) {
        self.level = level
        
        // Настраиваем layout для коллекции: размер ячеек, отступы и т.д.
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)      // Размер ячейки
        layout.minimumLineSpacing = 20                          // Отступ между строками
        layout.minimumInteritemSpacing = 20                     // Отступ между ячейками в строке
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20) // Отступы от краев
        
        self.rewardsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "Награды"
        
        setupCollectionView()
        loadRewardsForLevel(level)
    }
    
    private func setupCollectionView() {
        view.addSubview(rewardsCollectionView)
        rewardsCollectionView.dataSource = self
        rewardsCollectionView.delegate = self
        rewardsCollectionView.allowsSelection = true  // Обязательно, чтобы ячейки были кликабельны
        rewardsCollectionView.register(RewardCollectionViewCell.self, forCellWithReuseIdentifier: "RewardCell")
        rewardsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rewardsCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rewardsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            rewardsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rewardsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadRewardsForLevel(_ level: Int) {
        // Пример логики выдачи наград в зависимости от уровня
        if level < 5 {
            rewards = [
                Reward(name: "Сертификат на 10% скидку",
                       icon: UIImage(systemName: "star.fill")!,
                       description: "Получите скидку 10% на услуги фитнес-клуба."),
                Reward(name: "Медаль за прогресс",
                       icon: UIImage(systemName: "medal.fill")!,
                       description: "Получите медаль за прогресс в тренировках.")
            ]
        } else if level < 10 {
            rewards = [
                Reward(name: "Сертификат на 20% скидку",
                       icon: UIImage(systemName: "gift.fill")!,
                       description: "Получите скидку 20% на любые услуги клуба."),
                Reward(name: "Медаль за отличные результаты",
                       icon: UIImage(systemName: "medal.fill")!,
                       description: "Получите медаль за отличные результаты на тренировках.")
            ]
        } else {
            rewards = [
                Reward(name: "Сертификат на 50% скидку",
                       icon: UIImage(systemName: "gift.fill")!,
                       description: "Получите скидку 50% на все услуги клуба."),
                Reward(name: "Персональная тренировка с тренером",
                       icon: UIImage(systemName: "person.crop.circle.fill")!,
                       description: "Вам предоставляется персональная тренировка с тренером.")
            ]
        }
        
        rewardsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension RewardsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath) as! RewardCollectionViewCell
        let reward = rewards[indexPath.row]
        cell.configure(with: reward)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension RewardsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reward = rewards[indexPath.row]
        print("Нажата награда: \(reward.name)")
        let detailVC = RewardDetailViewController(reward: reward)
        // Если RewardsViewController находится в навигационном контроллере, используем push
        navigationController?.pushViewController(detailVC, animated: true)
        // ИЛИ можно использовать present(detailVC, animated: true)
    }
}
