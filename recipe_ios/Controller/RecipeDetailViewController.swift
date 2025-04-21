//
//  RecipeDetailViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    var recipeViewModel: RecipeViewModel!
    var recipeId: Int!
    private var currentRecipe: Recipe?
    private var favoriteButton: UIButton!
    var onRecipeDeleted: (() -> Void)?
    
    
    private lazy var customNavBar = NavBar(title: "")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .white
            view.addSubview(customNavBar)
            customNavBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                customNavBar.heightAnchor.constraint(equalToConstant: 60)
            ])
            
            customNavBar.onBackTapped = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
            loadRecipeDetails()
        }

    private func loadRecipeDetails() {
        // Always get fresh data from view model
        guard let recipe = recipeViewModel.getAllRecipes().first(where: { $0.id == recipeId }) else {
            print("Recipe not found")
            navigationController?.popViewController(animated: true)
            return
        }

        self.currentRecipe = recipe
        customNavBar.setTitle(recipe.name)
        
        // Clear existing UI and rebuild
        view.subviews.filter { $0 != customNavBar }.forEach { $0.removeFromSuperview() }
        setupUI(with: recipe)
    }

    
    private func setupUI(with recipe: Recipe) {
        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()
        
        let contentStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 16
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()
        
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            
            let imageName = recipe.imageUrl.replacingOccurrences(of: ".jpg", with: "")
                                          .replacingOccurrences(of: ".png", with: "")
            
            if let assetImage = UIImage(named: imageName) {
                imageView.image = assetImage
            }
            else if let documentImage = loadImageFromDocuments(fileName: recipe.imageUrl) {
                imageView.image = documentImage
            }
            else {
                imageView.image = UIImage(systemName: "photo")
                if !recipe.imageUrl.isEmpty {
                    print("⚠️ Couldn't find image: \(imageName) in assets or documents")
                }
            }
            
            return imageView
        }()
        
        favoriteButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "heart"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let editButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "pencil"), for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let deleteButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "trash"), for: .normal)
            button.setTitleColor(.blue, for: .normal)
            button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
            return button
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = recipe.name
            label.font = UIFont.boldSystemFont(ofSize: 28)
            label.numberOfLines = 0
            return label
        }()
        
        let titleStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 8
            stack.alignment = .center
            return stack
        }()
        
        let ingredientsLabelTitle: UILabel = {
            let label = UILabel()
            label.text = "Ingredients"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        let stepsLabelTitle: UILabel = {
            let label = UILabel()
            label.text = "Steps"
            label.font = UIFont.boldSystemFont(ofSize: 20)
            return label
        }()
        
        let ingredientsLabel: UILabel = {
            let label = UILabel()
            label.text = "• " + recipe.ingredients.joined(separator: "\n• ")
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            return label
        }()
        
        let stepsLabel: UILabel = {
            let label = UILabel()
            label.text = "" + recipe.steps.enumerated().map { "\($0 + 1). \($1)" }.joined(separator: "\n")
            label.font = UIFont.systemFont(ofSize: 16)
            label.numberOfLines = 0
            return label
        }()
        
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(editButton)
        titleStack.addArrangedSubview(deleteButton)
        titleStack.addArrangedSubview(favoriteButton)
        
        contentStack.addArrangedSubview(imageView)
        contentStack.addArrangedSubview(titleStack)
        contentStack.addArrangedSubview(ingredientsLabelTitle)
        contentStack.addArrangedSubview(ingredientsLabel)
        contentStack.addArrangedSubview(stepsLabelTitle)
        contentStack.addArrangedSubview(stepsLabel)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    @objc private func favoriteButtonTapped() {
        guard let recipe = currentRecipe else { return }

        let isFavorite = FavoriteManager.shared.isFavorite(recipe)

        if isFavorite {
            FavoriteManager.shared.removeFavorite(recipe)
            showAlert(title: "Removed from Favorites", message: "\(recipe.name) has been removed.")
        } else {
            FavoriteManager.shared.addFavorite(recipe)
            showAlert(title: "Added to Favorites", message: "\(recipe.name) is now in your favorites.")
        }
        
        updateFavoriteButton()
    }
    
    private func loadImageFromDocuments(fileName: String) -> UIImage? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        guard let documentsDirectory = urls.first else { return nil }

        let imageURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: imageURL.path)
    }

    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func updateFavoriteButton() {
        guard let recipe = currentRecipe else { return }
        let isFavorite = FavoriteManager.shared.isFavorite(recipe)
        let heartImage = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        favoriteButton.setImage(heartImage, for: .normal)
    }

    @objc private func editButtonTapped() {
        guard let recipe = currentRecipe else { return }

        let editVC = EditRecipeViewController()
        editVC.recipe = recipe
        editVC.recipeViewModel = recipeViewModel
        editVC.hidesBottomBarWhenPushed = true
        editVC.onRecipeUpdated = { [weak self] in
            self?.loadRecipeDetails()
        }
        navigationController?.pushViewController(editVC, animated: true)
    }

    @objc private func deleteButtonTapped() {
        guard let recipe = currentRecipe else { return }

        let alert = UIAlertController(title: "Delete Recipe",
                                      message: "Are you sure you want to delete this recipe?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.recipeViewModel.deleteRecipe(recipe)
            self.onRecipeDeleted?()
            self.navigationController?.popViewController(animated: true)
        }))
        
        present(alert, animated: true)
    }
}
