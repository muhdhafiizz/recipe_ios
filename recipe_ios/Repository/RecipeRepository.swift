//
//  RecipeRepository.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import Foundation

class RecipeRepository {
    
    private let recipeTypesFileName = "recipetypes.json"
    private let recipesFileName = "recipes.json"

    private var recipesFileURL: URL {
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return docDir.appendingPathComponent(recipesFileName)
    }

    // MARK: - Recipe Types
    func fetchRecipeTypes() -> [RecipeType] {
        guard let url = Bundle.main.url(forResource: recipeTypesFileName, withExtension: "") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let recipeTypes = try JSONDecoder().decode([RecipeType].self, from: data)
            return recipeTypes
        } catch {
            print("Error loading recipe types: \(error)")
            return []
        }
    }

    // MARK: - Recipes
    func fetchSampleRecipes() -> [Recipe] {
        var combinedRecipes = [Recipe]()
        
        if FileManager.default.fileExists(atPath: recipesFileURL.path) {
            do {
                let documentsData = try Data(contentsOf: recipesFileURL)
                let documentsRecipes = try JSONDecoder().decode([Recipe].self, from: documentsData)
                combinedRecipes.append(contentsOf: documentsRecipes)
                print("✅ Loaded \(documentsRecipes.count) recipes from Documents")
            } catch {
                print("❌ Error loading Documents recipes: \(error)")
            }
        }
        
        if let bundleURL = Bundle.main.url(forResource: "recipes", withExtension: "json") {
            do {
                let bundleData = try Data(contentsOf: bundleURL)
                let bundleRecipes = try JSONDecoder().decode([Recipe].self, from: bundleData)
                
                let newRecipes = bundleRecipes.filter { bundleRecipe in
                    !combinedRecipes.contains { $0.id == bundleRecipe.id }
                }
                
                combinedRecipes.append(contentsOf: newRecipes)
                print("✅ Added \(newRecipes.count) new recipes from Bundle")
            } catch {
                print("❌ Error loading Bundle recipes: \(error)")
            }
        }
        
        saveRecipes(combinedRecipes)
        return combinedRecipes
    }

    func saveRecipes(_ recipes: [Recipe]) {
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: recipesFileURL)
        } catch {
            print("Error saving recipes: \(error)")
        }
    }
}
