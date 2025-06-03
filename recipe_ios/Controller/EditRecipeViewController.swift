//
//  EditRecipeViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit

class EditRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var recipeViewModel: RecipeViewModel!
    var recipe: Recipe!
    var onRecipeUpdated: (() -> Void)?

    private lazy var customNavBar = NavBar(title: "Edit Recipe")

    private let scrollView = UIScrollView()
    private let contentView = UIView()

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
        view.backgroundColor = .systemBackground

        view.addSubview(customNavBar)
        customNavBar.onBackTapped = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        setupUI()
        populateFields()
    }

    private func setupUI() {
        customNavBar.translatesAutoresizingMaskIntoConstraints = false

        imageButton.setTitle("Change Image", for: .normal)
        imageButton.addTarget(self, action: #selector(selectImageTapped), for: .touchUpInside)
        imageButton.translatesAutoresizingMaskIntoConstraints = false

        ingredientsStackView.axis = .vertical
        ingredientsStackView.spacing = 8
        ingredientsStackView.translatesAutoresizingMaskIntoConstraints = false

        stepsStackView.axis = .vertical
        stepsStackView.spacing = 8
        stepsStackView.translatesAutoresizingMaskIntoConstraints = false

        let addIngredientButton = CustomButton(title: "Add Ingredient", backgroundColor: .blue, titleColor: .label, cornerRadius: 10, font: .systemFont(ofSize: 18, weight: .semibold))
        addIngredientButton.addTarget(self, action: #selector(addIngredientField), for: .touchUpInside)

        let addStepButton = CustomButton(title: "Add Step", backgroundColor: .blue, titleColor: .label, cornerRadius: 10, font: .systemFont(ofSize: 18, weight: .semibold))
        addStepButton.addTarget(self, action: #selector(addStepField), for: .touchUpInside)

        let saveButton = CustomButton(title: "Save Changes", backgroundColor: .white, titleColor: .blue, cornerRadius: 10, borderColor: .blue, borderWidth: 3, font: .systemFont(ofSize: 18, weight: .semibold))
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)

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

        // Add scroll view + content view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            customNavBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavBar.heightAnchor.constraint(equalToConstant: 60),

            scrollView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
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

    private func populateFields() {
        nameTextField.text = recipe.name
        selectedImage = loadImageFromDisk(with: recipe.imageUrl)
        if selectedImage != nil {
            imageButton.setTitle("Image Selected", for: .normal)
        }
        
        recipe.ingredients.forEach { ingredient in
            let field = CustomTextField(placeholder: "Enter ingredient")
            field.text = ingredient
            ingredientFields.append(field)
            ingredientsStackView.addArrangedSubview(field)
        }

        recipe.steps.forEach { step in
            let field = CustomTextField(placeholder: "Enter step")
            field.text = step
            stepFields.append(field)
            stepsStackView.addArrangedSubview(field)
        }
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

    @objc private func selectImageTapped() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imageButton.setTitle("Image Selected", for: .normal)
        }
        dismiss(animated: true)
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

        let imageUrl = selectedImage != nil ? saveImageToDisk(image: selectedImage!) : recipe.imageUrl

        let updatedRecipe = Recipe(
            id: recipe.id,
            name: name,
            imageUrl: imageUrl,
            ingredients: ingredients,
            steps: steps,
            typeId: recipe.typeId,
            isFavorite: recipe.isFavorite
        )

        recipeViewModel.updateRecipe(updatedRecipe)
        onRecipeUpdated?()
        navigationController?.popViewController(animated: true)
    }

    private func saveImageToDisk(image: UIImage) -> String {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return recipe.imageUrl }

        let filename = "\(UUID().uuidString).jpg"
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = directory.appendingPathComponent(filename)

        do {
            try data.write(to: path)
            return filename
        } catch {
            print("Failed to save image: \(error)")
            return recipe.imageUrl
        }
    }

    private func loadImageFromDisk(with filename: String) -> UIImage? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = directory.appendingPathComponent(filename)
        return UIImage(contentsOfFile: path.path)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Missing Info", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
