//
//  Recipe.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import Foundation


struct Recipe: Codable {
    let id: Int
    let name: String
    let imageUrl: String
    let ingredients: [String]
    let steps: [String]
    let typeId: Int
    let isFavorite: Bool
}
