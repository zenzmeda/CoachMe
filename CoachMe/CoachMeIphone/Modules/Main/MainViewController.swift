//
//  ViewController.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//
import UIKit
import CoreData

class MainViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad called")
        // Создаем объект User и сохраняем в Core Data
        createUser()
        
        // Извлекаем и выводим пользователя, чтобы убедиться, что данные сохранились
        fetchUser()
    }
    
    // Создание объекта User
    func createUser() {
        // Получаем контекст Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Создаем нового пользователя
        let user = User(context: context)
        user.id = UUID()
        user.name = "Vadim"
        user.avatar = "empty"
        
        print("Saving user to Core Data...")
        // Сохраняем данные в Core Data
        do {
            try context.save()
            print("User created and saved successfully")
        } catch {
            print("Failed to save user: \(error)")
        }
    }
    
    // Извлечение данных из Core Data
    
    func fetchUser() {
        // Получаем контекст Core Data
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Создаем запрос для получения всех пользователей
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            let users = try context.fetch(request)
            if let firstUser = users.first {
                print("Fetched user: \(firstUser.name ?? "No name")")
            } else {
                print("No users found")
            }
        } catch {
            print("Failed to fetch users: \(error)")
        }
    }
}



