//
//  FavoriteManager.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    
    private let favoritesKey = "favoriteRecipes"

    private init() {}

    func addFavorite(_ recipe: Recipe) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.id == recipe.id }) {
            favorites.append(recipe)
            saveFavorites(favorites)
        }
    }

    func removeFavorite(_ recipe: Recipe) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == recipe.id }
        saveFavorites(favorites)
    }

    func isFavorite(_ recipe: Recipe) -> Bool {
        return getFavorites().contains(where: { $0.id == recipe.id })
    }

    func getFavorites() -> [Recipe] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else {
            return []
        }
        let decoder = JSONDecoder()
        return (try? decoder.decode([Recipe].self, from: data)) ?? []
    }

    private func saveFavorites(_ favorites: [Recipe]) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(favorites) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
}

