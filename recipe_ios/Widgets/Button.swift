//
//  Button.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 19/04/2025.
//

import UIKit

class CustomButton: UIButton {
    
    init(title: String,
         backgroundColor: UIColor = .systemBlue,
         titleColor: UIColor = .white,
         cornerRadius: CGFloat = 8,
         borderColor: UIColor = UIColor.black.withAlphaComponent(0.8),
         borderWidth: CGFloat = 1.0,
         font: UIFont = .systemFont(ofSize: 16, weight: .bold),
         height: CGFloat = 50) {
        
        super.init(frame: .zero)
        
        self.setTitle(title, for: .normal)
        self.backgroundColor = backgroundColor
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.titleLabel?.font = font
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Fixed height constraint
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

