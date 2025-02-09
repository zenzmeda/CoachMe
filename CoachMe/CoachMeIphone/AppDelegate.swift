//
//  AppDelegate.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate { 
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores {_, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges{
            do{
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
   
    // MARK: - Application Lifecycle
       func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           print("HERE")
           // Здесь можно настроить глобальные компоненты, например Core Data или настройки уведомлений
           return true
       }
       
       func applicationWillResignActive(_ application: UIApplication) {
           // Обработка выхода приложения из активного состояния
       }

       func applicationDidEnterBackground(_ application: UIApplication) {
           // Обработка перехода приложения в фон
       }

       func applicationWillEnterForeground(_ application: UIApplication) {
           // Обработка возвращения приложения из фона
       }

       func applicationDidBecomeActive(_ application: UIApplication) {
           // Обработка возвращения приложения в активное состояние
       }
       
       func applicationWillTerminate(_ application: UIApplication) {
           // Сохранение данных перед завершением приложения
       }
}

