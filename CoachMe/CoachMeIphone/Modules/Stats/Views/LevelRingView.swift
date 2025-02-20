//
//  LevelRingView.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 20.02.2025.
//

import UIKit

class LevelRingView: UIView {
    private let shapeLayer = CAShapeLayer()
    private var levelLabel = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: 50, y: 50), radius: 80, startAngle: -CGFloat.pi / 2, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor(red: 0.96, green: 0.87, blue: 0.70, alpha: 1.0).cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        layer.addSublayer(shapeLayer)
        
            levelLabel.text = "1"
            levelLabel.textColor = UIColor.white
            levelLabel.font = UIFont.boldSystemFont(ofSize: 24)
            levelLabel.textAlignment = .center
            levelLabel.translatesAutoresizingMaskIntoConstraints = false
            addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
               levelLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
               levelLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
           ])
    }
    
    func setLevelLabel(_ level: Int){
        levelLabel.text = String(level)
    }
    
    func setProgress(_ progress: Float) {
        shapeLayer.strokeEnd = CGFloat(progress)
    }
}


