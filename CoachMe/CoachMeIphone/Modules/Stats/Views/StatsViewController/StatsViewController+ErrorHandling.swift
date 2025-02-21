//
//  StatsViewController+ErrorHandling.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 21.02.2025.
//

import UIKit
extension StatsViewController{
    internal func showError(_ error: Error) {
        let message = error.localizedDescription.isEmpty ? "Неизвестная ошибка" : error.localizedDescription
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    
    internal func showNoDataMessage() {
        let alert = UIAlertController(title: "Нет данных", message: "Для отображения статистики требуется больше информации.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
}

