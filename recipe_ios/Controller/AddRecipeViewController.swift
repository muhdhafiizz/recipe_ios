//
//  AddRecipeViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 16/04/2025.
//

import UIKit

class AddRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var recipeViewModel: RecipeViewModel!
    var onRecipeAdded: (() -> Void)?
    
    
    private lazy var customNavBar = NavBar(title: "Add Recipe")

    private let recipeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Recipe Name"
        textView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textView.isScrollEnabled = false
        return textView
    }()
    
    private let nameTextField = CustomTextField(placeholder: "Enter Recipe Name")
    private let imageButton = UIButton(type: .system)
    
    private let ingredientsStackView = UIStackView()
    private let stepsStackView = UIStackView()
        
    private var ingredientFields: [CustomTextField] = []
    private var stepFields: [CustomTextField] = []

    
    private var selectedImage: UIImage?
    
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
        view.addSubview(customNavBar)
        view.backgroundColor = .white
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        setupUI()
    }
    
    private func setupUI() {
        
        imageButton.setTitle("Select Image", for: .normal)
        imageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        imageButton.translatesAutoresizingMaskIntoConstraints = false
        
        ingredientsStackView.axis = .vertical
        ingredientsStackView.spacing = 8
        ingredientsStackView.translatesAutoresizingMaskIntoConstraints = false
        addIngredientField()
        
        stepsStackView.axis = .vertical
        stepsStackView.spacing = 8
        stepsStackView.translatesAutoresizingMaskIntoConstraints = false
        addStepField()

        
        let addIngredientButton: CustomButton = {
            let button = CustomButton(title: "Add Ingridient",  backgroundColor: .blue,
                                      titleColor: .white,
                                      cornerRadius: 10,
                                      font: .systemFont(ofSize: 18, weight: .semibold))
            button.addTarget(self, action: #selector(addIngredientField), for: .touchUpInside)

            return button
        }()
        
        let addStepButton: CustomButton = {
            let button = CustomButton(title: "Add Step",  backgroundColor: .blue,
                                      titleColor: .white,
                                      cornerRadius: 10,
                                      font: .systemFont(ofSize: 18, weight: .semibold))
            button.addTarget(self, action: #selector(addStepField), for: .touchUpInside)

            return button
        }()
        
        let saveButton: CustomButton = {
            let button = CustomButton(title: "Save Recipe",  backgroundColor: .white,titleColor: .blue,
                cornerRadius: 10,
                borderColor: .blue,
                borderWidth: 3,
                font: .systemFont(ofSize: 18, weight: .semibold))
            button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
            return button
        }()
                     
        let stackView = UIStackView(arrangedSubviews: [
            recipeTextView,
            nameTextField,
            imageButton,
            labeledStack("Ingredients", ingredientsStackView, addIngredientButton),
            labeledStack("Steps", stepsStackView, addStepButton),
            saveButton
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 60),
            
            stackView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func labeledStack(_ title: String, _ stack: UIStackView, _ button: UIButton) -> UIStackView {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let vertical = UIStackView(arrangedSubviews: [label, stack, button])
        vertical.axis = .vertical
        vertical.spacing = 8
        return vertical
    }
    
    @objc private func addIngredientField() {
        let newIngredientField = CustomTextField(placeholder: "Enter ingredient")
        ingredientFields.append(newIngredientField)
        ingredientsStackView.addArrangedSubview(newIngredientField)
    }

    @objc private func addStepField() {
        let newStepField = CustomTextField(placeholder: "Enter step")
        stepFields.append(newStepField)
        stepsStackView.addArrangedSubview(newStepField)
    }

    
    private func makeTextField(placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.placeholder = placeholder
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert("Please fill in the name.")
            return
        }
        
        let ingredients = ingredientFields.compactMap { $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let steps = stepFields.compactMap { $0.text?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        
        if ingredients.isEmpty || steps.isEmpty {
            showAlert("Please add at least one ingredient and one step.")
            return
        }
        
        guard let selectedImage = selectedImage else {
            showAlert("Please select an image for the recipe.")
            return
        }
        
        let newRecipe = Recipe(
            id: Int.random(in: 100...999),
            name: name,
            imageUrl: saveImageToDisk(image: selectedImage),
            ingredients: ingredients,
            steps: steps,
            typeId: 1,
            isFavorite: false
        )
        
        recipeViewModel.addRecipe(newRecipe)
        onRecipeAdded?()

        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func selectImageTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageButton.setTitle("Image Selected", for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func saveImageToDisk(image: UIImage) -> String {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return "" }

        let filename = "\(UUID().uuidString).jpg"
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imagePath = directory.appendingPathComponent(filename)

        do {
            try data.write(to: imagePath)
            return filename // return just the filename, not the full path
        } catch {
            print("Error saving image: \(error)")
            return ""
        }
    }

}
