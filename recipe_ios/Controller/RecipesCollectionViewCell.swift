//
//  RecipeFavoriteCollectionViewCell.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class RecipesCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecipesCollectionViewCell"
    
    private let nameLabel = UILabel()
    private let recipeImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .white
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.1
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        contentView.layer.masksToBounds = false
                
        recipeImageView.contentMode = .scaleAspectFill
        recipeImageView.clipsToBounds = true
        recipeImageView.layer.cornerRadius = 12  // Added corner radius to image
        recipeImageView.translatesAutoresizingMaskIntoConstraints = false
                contentView.addSubview(recipeImageView)
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        // Set up the layout of the image and the label
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with recipe: Recipe) {
        nameLabel.text = recipe.name
        
        if !recipe.imageUrl.isEmpty {
            // 1. Remove file extension if present in your asset names
            let imageName = recipe.imageUrl.replacingOccurrences(of: ".jpg", with: "")
                                          .replacingOccurrences(of: ".png", with: "")
            
            // 2. First try to load from Assets catalog
            if let assetImage = UIImage(named: imageName) {
                recipeImageView.image = assetImage
            }
            // 3. Fallback to Documents directory (for downloaded/saved images)
            else {
                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                let fullImagePath = documentsURL.appendingPathComponent(recipe.imageUrl).path
                
                if FileManager.default.fileExists(atPath: fullImagePath),
                   let documentImage = UIImage(contentsOfFile: fullImagePath) {
                    recipeImageView.image = documentImage
                }
                // 4. Final fallback to system image
                else {
                    print("⚠️ Couldn't find image: \(imageName) in assets or documents")
                    recipeImageView.image = UIImage(systemName: "photo")
                }
            }
        } else {
            recipeImageView.image = UIImage(systemName: "photo")
        }
    }

}

