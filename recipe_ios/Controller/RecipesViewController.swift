//
//  RecipeFavoriteViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class RecipeWatchlistView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var recipes: [Recipe] = [] {
        didSet {
            collectionView.reloadData()
            emptyStateView.isHidden = !recipes.isEmpty
        }
    }
    var onViewAllTapped: (() -> Void)?
    var didSelectRecipe: ((Recipe) -> Void)?
    
    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let icon = UIImageView(image: UIImage(systemName: "face.smiling.inverse"))
        icon.tintColor = .secondaryLabel
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = "Your recipe is currently empty.\nPlease create a recipe."
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(icon)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 175),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30),
            label.bottomAnchor.constraint(equalTo: icon.topAnchor, constant: -16),
            
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 175),
        ])
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 140, height: 150)
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(RecipesCollectionViewCell.self, forCellWithReuseIdentifier: RecipesCollectionViewCell.identifier)
        cv.register(ViewAllCollectionViewCell.self, forCellWithReuseIdentifier: ViewAllCollectionViewCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(collectionView)
        addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            emptyStateView.topAnchor.constraint(equalTo: topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func update(recipes: [Recipe]) {
        self.recipes = recipes
        emptyStateView.isHidden = !recipes.isEmpty
    }

    
    // MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(recipes.count, 4) + (recipes.count > 4 ? 1 : 0)
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 4 && recipes.count > 4 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ViewAllCollectionViewCell.identifier,
                for: indexPath
            ) as? ViewAllCollectionViewCell else {
                return UICollectionViewCell()
            }
            return cell
        } else {
            let actualIndex = indexPath.item
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RecipesCollectionViewCell.identifier,
                for: indexPath
            ) as? RecipesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: recipes[actualIndex])
            return cell
        }
    }


    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 4 && recipes.count > 4 {
            onViewAllTapped?()
        } else {
            let recipe = recipes[indexPath.item]
            didSelectRecipe?(recipe)
        }
    }

}

