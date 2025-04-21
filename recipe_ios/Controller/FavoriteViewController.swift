//
//  FavoriteViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class FavoriteRecipesView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var recipes: [Recipe] = [] {
        didSet {
            collectionView.reloadData()
            emptyStateView.isHidden = !recipes.isEmpty
        }
    }
    
    var didSelectRecipe: ((Recipe) -> Void)?

    private let emptyStateView: UIView = {
        let view = UIView()
        view.isHidden = true
        
        let icon = UIImageView(image: UIImage(systemName: "face.smiling.inverse"))
        icon.tintColor = .gray
        icon.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.text = "Your favorite is currently empty.\nPlease add a favorite recipe."
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(icon)
        view.addSubview(label)

        NSLayoutConstraint.activate([
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -16),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 16)
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
        cv.delegate = self
        cv.dataSource = self
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(collectionView)
        addSubview(emptyStateView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

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

    // MARK: Collection View

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipesCollectionViewCell.identifier, for: indexPath) as? RecipesCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: recipes[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.item]
        didSelectRecipe?(recipe)
    }
}
