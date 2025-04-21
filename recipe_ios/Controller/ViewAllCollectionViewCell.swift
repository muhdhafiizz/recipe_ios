//
//  ViewAllCollectionViewCell.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 20/04/2025.
//

import UIKit

class ViewAllCollectionViewCell: UICollectionViewCell {
    static let identifier = "ViewAllCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "View All"
        label.textAlignment = .center
        label.textColor = .systemBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.systemGray6
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
