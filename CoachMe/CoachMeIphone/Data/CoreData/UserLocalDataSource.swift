//
//  UserLocalDataSource.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 13.02.2025.
//

import CoreData

class UserLocalDataSource {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func saveUserToLocalDB(user: UserModel) throws -> StatusUser{
        let fetchRequest: NSFetchRequest <User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "userName == %@", user.id.uuidString)
        let existingUsers = try context.fetch(fetchRequest)
        if let _ = existingUsers.first{
            return StatusUser.alreadyExists
        } else {
            let _ = user.toCoreDataModel(context: context)
        }
        try context.save()
        return StatusUser.success
    }
    
    func saveWorkoutsToLocalDB(workouts: [Stats], user: UserModel) throws -> Result<Void,RegisterError> {
        let fetchRequest: NSFetchRequest <User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", user.id.uuidString)
        do{
            let existingUsers = try context.fetch(fetchRequest)
            guard let existingUser = existingUsers.first else {return .failure(.userAbsentError)}
            
            for workout in workouts {
                let newWorkout = workout.statsToCoreData(context: context)
                newWorkout.user = existingUser
            }
            try context.save()
            return .success(())
        } catch {
            return .failure(.unknownError)
        }
    }
    
    func saveTrainerToLocalDB(trainer: TrainerModel) throws -> RegisterTrainer {
        let fetchRequest: NSFetchRequest<Trainer> = Trainer.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", trainer.id.uuidString)

            let existingTrainers = try context.fetch(fetchRequest)
            
            // Проверяем, если такой тренер уже существует
        if let _ = existingTrainers.first {
            return RegisterTrainer.trainerExists
            } else {
                let _ = trainer.toCoreDataModel(context: context)
                try context.save()
                return RegisterTrainer.createTrainer
            }
        }
    
    
    //Создание контекста для тестов
    static func createTestContext() -> NSManagedObjectContext {
           let persistentContainer = NSPersistentContainer(name: "DataModel")
           persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null") // Чтобы не использовать реальную БД
           persistentContainer.loadPersistentStores { _, error in
               if let error = error {
                   fatalError("Failed to load persistent stores: \(error)")
               }
           }
           return persistentContainer.viewContext
       }
    
    
}
