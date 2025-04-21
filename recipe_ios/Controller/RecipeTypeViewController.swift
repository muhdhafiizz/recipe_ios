//
//  RecipeTypeViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class RecipeTypeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var recipeViewModel: RecipeViewModel!
    private var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeViewModel = RecipeViewModel(repository: RecipeRepository())
        
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(pickerView)
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // UIPickerView DataSource methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeViewModel.getRecipeTypes().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return recipeViewModel.getRecipeTypes()[row]
    }
}
