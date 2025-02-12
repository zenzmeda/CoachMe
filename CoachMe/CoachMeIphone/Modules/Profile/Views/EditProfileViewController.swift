//
//  EditProfileViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//
import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var viewModel: EditProfileViewModel
    
    private let nameTextField = UITextField()
    private let avatarImageView = UIImageView()
    private let saveButton = UIButton()
    private let changeAvatarButton = UIButton()
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        nameTextField.borderStyle = .roundedRect
        nameTextField.placeholder = "Введите имя"
        view.addSubview(nameTextField)
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        view.addSubview(avatarImageView)
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.8, green: 0.7, blue: 0.5, alpha: 1.0) // Темный бежевый
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.layer.cornerRadius = 10
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        changeAvatarButton.setTitle("Изменить аватар", for: .normal)
                changeAvatarButton.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
                changeAvatarButton.layer.cornerRadius = 10
                changeAvatarButton.addTarget(self, action: #selector(changeAvatarButtonTapped), for: .touchUpInside)
                view.addSubview(changeAvatarButton)
        
        nameTextField.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 40)
        avatarImageView.frame = CGRect(x: (view.frame.width - 100) / 2, y: 160, width: 100, height: 100)
        saveButton.frame = CGRect(x: 20, y: 280, width: view.frame.width - 40, height: 50)
        changeAvatarButton.frame = CGRect(x: (view.frame.width - 200) / 2, y: 340, width: 200, height: 40)
    }
    
    @objc func saveButtonTapped() {
        let newName = "Новое имя" // Получить от пользователя
        let newAvatar = avatarImageView.image?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? viewModel.userAvatar
        viewModel.saveChanges(newName: newName, newAvatar: newAvatar)
        navigationController?.popViewController(animated: true)
    }
    
    private func populateData() {
        // Заполняем текстовые поля данными из ViewModel
        nameTextField.text = viewModel.userName
        avatarImageView.image = UIImage(named: viewModel.userAvatar)
    }
    
    @objc private func changeAvatarButtonTapped() {
            // Проверяем доступность галереи
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                present(picker, animated: true, completion: nil)
            }
        }
}
