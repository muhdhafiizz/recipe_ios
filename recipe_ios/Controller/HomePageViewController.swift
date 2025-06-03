//
//  HomePageViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit
import FirebaseAuth

class HomePageViewController: UIViewController {
    
    private var recipeViewModel: RecipeViewModel!
    private var watchlistView: RecipeWatchlistView!
    private var favoriteView: FavoriteRecipesView!
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()

    private let userLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .label
        return label
    }()

    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        loadFavorites()
        loadRecipe()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        recipeViewModel = RecipeViewModel(repository: RecipeRepository())
        setupUI()
        if let currentUser = Auth.auth().currentUser {
            userLabel.text = currentUser.displayName ?? "User"
        }
        loadFavorites()
        loadRecipe()
    }
    
    private func setupUI() {
        // MARK: - Scroll View Setup
        let scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            return scrollView
        }()

        let contentStack: UIStackView = {
            let stack = UIStackView()
            stack.axis = .vertical
            stack.spacing = 24
            stack.translatesAutoresizingMaskIntoConstraints = false
            return stack
        }()

        let welcomeStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [welcomeLabel, userLabel])
            stack.axis = .vertical
            stack.spacing = 4
            return stack
        }()

        let navBarStack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [welcomeStack, searchButton])
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            return stack
        }()

        let titleRow: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.distribution = .equalSpacing
            stack.alignment = .center
            return stack
        }()

        let recipesLabel: UILabel = {
            let label = UILabel()
            label.text = "Recipes"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            return label
        }()

        let addRecipeButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = .blue
            button.setTitleColor(.blue, for: .normal)
            button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.addTarget(self, action: #selector(addRecipeButtonTapped), for: .touchUpInside)
            return button
        }()

        // MARK: - Watchlist View
        watchlistView = {
            let view = RecipeWatchlistView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 160).isActive = true
            view.update(recipes: recipeViewModel.getAllRecipes())

            view.onViewAllTapped = { [weak self] in
                guard let self = self else { return }
                let searchVC = SearchListViewController()
                searchVC.allRecipes = recipeViewModel.getAllRecipes()
                searchVC.recipeViewModel = recipeViewModel
                searchVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(searchVC, animated: true)
            }

            view.didSelectRecipe = { [weak self] recipe in
                self?.showRecipeDetail(for: recipe)
            }

            return view
        }()

        // MARK: - Favorites Section
        let favoritesLabel: UILabel = {
            let label = UILabel()
            label.text = "Favorites"
            label.font = UIFont.boldSystemFont(ofSize: 30)
            return label
        }()

        favoriteView = {
            let view = FavoriteRecipesView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 160).isActive = true
            view.didSelectRecipe = { [weak self] recipe in
                self?.showRecipeDetail(for: recipe)
            }
            return view
        }()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        contentStack.addArrangedSubview(navBarStack)
        titleRow.addArrangedSubview(recipesLabel)
        titleRow.addArrangedSubview(addRecipeButton)
        contentStack.addArrangedSubview(titleRow)
        contentStack.addArrangedSubview(watchlistView)
        contentStack.addArrangedSubview(favoritesLabel)
        contentStack.addArrangedSubview(favoriteView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])

    }


    @objc private func addRecipeButtonTapped() {
        let addVC = AddRecipeViewController()
        addVC.recipeViewModel = recipeViewModel
        addVC.hidesBottomBarWhenPushed = true
        addVC.onRecipeAdded = { [weak self] in
            self?.watchlistView.update(recipes: self?.recipeViewModel.getAllRecipes() ?? [])
        }
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    @objc private func searchButtonTapped() {
        let searchVC = SearchListViewController()
        searchVC.allRecipes = recipeViewModel.getAllRecipes()
        searchVC.recipeViewModel = recipeViewModel
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }

    
    private func loadFavorites() {
        let favorites = FavoriteManager.shared.getFavorites()
        favoriteView.recipes = favorites
    }
    
    
    private func loadRecipe() {
        let recipe = recipeViewModel.getAllRecipes()
        watchlistView.update(recipes: recipe)
    }

    
    private func showRecipeDetail(for recipe: Recipe) {
        let detailVC = RecipeDetailViewController()
        detailVC.recipeId = recipe.id
        detailVC.recipeViewModel = recipeViewModel
        detailVC.hidesBottomBarWhenPushed = true
        detailVC.onRecipeDeleted = { [weak self] in
            self?.watchlistView.update(recipes: self?.recipeViewModel.getAllRecipes() ?? [])
            self?.loadFavorites()
        }
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
