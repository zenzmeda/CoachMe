//
//  EditProfileViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//
import UIKit

#Preview {
    let workout1 = Stats(exerciseName: "Отжимания", workingWeight: 10, repetitions: 1000, sets: 3, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Отжимания", repetitions: 2, sets: 2))
    let workout2 = Stats(exerciseName: "Подтягивания", workingWeight: 10, repetitions: 2, sets: 5, date: Date(), status: .confirmed, exp: Stats.countEx(exerciseName: "Подтягивания", repetitions: 2, sets: 2))
    let workout3 = Stats(exerciseName: "Становая тяга", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .inProgress)
    let workout4 = Stats(exerciseName: "Приседания", workingWeight: 20, repetitions: 220, sets: 2, date: Date(), status: .awaitingConfirmation)
    let progress: [Stats] = [workout1, workout2, workout3, workout4]
        let trainer1 = TrainerModel(id: UUID(), coachCode: "COACH001", userName: "Тренер Алексей")
    let trainer2 = TrainerModel(id: UUID(), coachCode: "COACH002", userName: "Тренер Ольга")
    let trainer3 = TrainerModel(id: UUID(), coachCode: "COACH003", userName: "Тренер Дмитрий")
    let userTrainer = UserModel(id: trainer1.id, name: "Алексей", avatar: "default", progress: progress, status: .inGym, email: "default@default.ru", userName: "Тренер Алексей", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 1)
    let currentUser = UserModel(id: UUID(), name: "Vadim", avatar: "default_avatar", progress: progress, status: .inGym, email: "default@default.ru", userName: "Vadim", phoneNumber: "89132056827", gender: .male, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let user = UserModel(id: UUID(), name: "vadim", avatar: "defuult", progress: progress, status: .outGym, email: "@", userName: "Vadim", phoneNumber: "898989898899", gender: .female, birthday: Date(), gym: .KrasnyiProspect, statusTrainer: 0)
    let users: [UserModel] = [userTrainer, currentUser, user]
    let trainer: [TrainerModel] = [trainer1, trainer2, trainer3]
    
    let apiService = MockAPIService(users: users, trainer: trainer)
    let dataService = UserLocalDataSource(context: UserLocalDataSource.createTestContext())
    let userRepository = UserRepository(apiService: apiService, dataService: dataService)
    let editVM = EditProfileViewModel(reposytory: userRepository, currentUser: currentUser)
    let edicC = EditProfileViewController(viewModel: editVM)
    let navigationController = UINavigationController(rootViewController: edicC)
    return navigationController

}

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var viewModel: EditProfileViewModel
    
    weak var delegate: EditProfileDelegate?
    
    private let nameTextField = UITextField()
    private let avatarImageView = UIImageView()
    private let saveButton = UIButton()
    private let changeAvatarButton = UIButton()
    
    init(viewModel: EditProfileViewModel, delegate: EditProfileDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
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
    
    @objc func saveButtonTapped(){
        viewModel.setName(nameTextField.text)
        
        // Проверяем, есть ли изображение
        if let avatarImage = avatarImageView.image {
            // Сохраняем изображение в файловой системе
            if let imagePath = saveImageToFileSystem(image: avatarImage) {
                // Передаем путь к изображению
                viewModel.setAvatar(imagePath)
            }
        } else {
            showAlert(message: "Пожалуйста, выберите аватар.")
            return
        }
        
        let newAvatar = avatarImageView.image?.jpegData(compressionQuality: 0.8)?.base64EncodedString() ?? viewModel.getNewAvatar()
        do {
            try viewModel.saveChanges(newName: viewModel.getNewName(), newAvatar: newAvatar)
            populateData()
            delegate?.loadUserData()
            navigationController?.popViewController(animated: true)
            
        } catch {
            showAlert(message: "Ошибка при сохранении данных. Попробуйте снова.")
            print("Ошибка сохранения: \(error)")
        }
    }
    
    func saveImageToFileSystem(image: UIImage) -> String? {
        let fileName = UUID().uuidString + ".png"
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        if let data = image.pngData() {
            do {
                try data.write(to: fileURL)
                return fileURL.path
            } catch {
                print("Ошибка при сохранении изображения: \(error)")
            }
        }
        return nil
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.editedImage] as? UIImage {
            avatarImageView.image = selectedImage
        } else if let selectedImage = info[.originalImage] as? UIImage {
            avatarImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    private func populateData() {
        // Заполняем текстовые поля данными из ViewModel
        nameTextField.text = viewModel.getNewName()
        if viewModel.getNewAvatar() == "default_avatar"{
            avatarImageView.image = UIImage(named: viewModel.getNewAvatar())
        }else {
            avatarImageView.image = UIImage(data: Data(base64Encoded: viewModel.getNewAvatar()) ?? Data())
        }
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
