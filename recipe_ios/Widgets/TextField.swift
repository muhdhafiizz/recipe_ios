//
//  TextField.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 19/04/2025.
//

import UIKit

class CustomTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    
    init(placeholder: String,
         height: CGFloat = 50,
         isSecureTextEntry: Bool = false,
         borderColor: UIColor = .blue,
         borderWidth: CGFloat = 1.0,
         cornerRadius: CGFloat = 8,
         textColor: UIColor = .secondaryLabel,
         autocapitalization: UITextAutocapitalizationType = .none) {
        
        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.autocapitalizationType = autocapitalization
        self.isSecureTextEntry = isSecureTextEntry
        self.translatesAutoresizingMaskIntoConstraints = false
        self.borderStyle = .none
        
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.textColor = textColor

        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Padding Overrides
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

