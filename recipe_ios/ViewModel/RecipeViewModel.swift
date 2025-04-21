//
//  RecipeViewModel.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import Foundation

class RecipeViewModel {
    private var recipeRepository: RecipeRepository
    private(set) var recipeTypes: [RecipeType]
    private(set) var recipes: [Recipe]
    
    init(repository: RecipeRepository) {
        self.recipeRepository = repository
        self.recipeTypes = recipeRepository.fetchRecipeTypes()
        
        self.recipes = recipeRepository.fetchSampleRecipes()
        print("Loaded recipes: \(self.recipes)")

    }
    
    func getRecipeTypes() -> [String] {
        return recipeTypes.map { $0.name }
    }
    
    func getRecipes(for typeId: Int) -> [Recipe] {
        return recipes.filter { $0.typeId == typeId }
    }
    
    func addRecipe(_ recipe: Recipe) {
        recipes.append(recipe)
        recipeRepository.saveRecipes(recipes) 
    }
    
    func getAllRecipes() -> [Recipe] {
        return recipes
    }
    
    func getFavoriteRecipes() -> [Recipe] {
        return recipes.filter { $0.isFavorite }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        recipeRepository.saveRecipes(recipes)
    }
    
    func updateRecipe(_ updatedRecipe: Recipe) {
        if let index = recipes.firstIndex(where: { $0.id == updatedRecipe.id }) {
            recipes[index] = updatedRecipe
            recipeRepository.saveRecipes(recipes)
        }
    }




}
