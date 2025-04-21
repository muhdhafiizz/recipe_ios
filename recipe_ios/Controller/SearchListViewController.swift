//
//  SearchListViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 20/04/2025.
//

import UIKit

class SearchListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var allRecipes: [Recipe] = []
    private var filteredRecipes: [Recipe] = []
    var recipeViewModel: RecipeViewModel!

    private lazy var customNavBar = NavBar(title: "Search")
    
    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true

        allRecipes = recipeViewModel.getAllRecipes()
        if let searchText = searchBar.text, !searchText.isEmpty {
            filteredRecipes = allRecipes.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredRecipes = allRecipes
        }
        tableView.reloadData()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(customNavBar)
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        searchBar.delegate = self
        searchBar.placeholder = "Search recipes..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),            searchBar.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        filteredRecipes = allRecipes
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipe = filteredRecipes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        cell.configure(title: recipe.name, icon: UIImage(systemName: "fork.knife"))
        return cell
    }

    // Optional: handle tap
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedRecipe = filteredRecipes[indexPath.row]
        
        let detailVC = RecipeDetailViewController()
        detailVC.recipeId = selectedRecipe.id
        detailVC.recipeViewModel = recipeViewModel
        detailVC.onRecipeDeleted = { [weak self] in
            self?.allRecipes = self?.recipeViewModel.getAllRecipes() ?? []
            self?.searchBar.text = ""
            self?.filteredRecipes = self?.allRecipes ?? []
            self?.tableView.reloadData()
        }

        navigationController?.pushViewController(detailVC, animated: true)
    }

    
    // MARK: - Search
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredRecipes = allRecipes
        } else {
            filteredRecipes = allRecipes.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
