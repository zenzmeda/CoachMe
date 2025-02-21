//
//  EditProfileViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//
import Foundation
import Combine

class EditProfileViewModel {
    private var reposytory: UserReposytoryProtocol
    
    @Published var currentUser: UserModel
    @Published var statusLoading = false
    
    init(reposytory: UserReposytoryProtocol, currentUser: UserModel) {
        self.reposytory = reposytory
        self.currentUser = currentUser
    }
    
    func  getUser() throws -> UserModel {
        try reposytory.fetchUserFromDB(userName: currentUser.name)
    }
    
    func getAvatar () throws -> String{
        let newCurrentUser = try reposytory.fetchUserFromDB(userName: currentUser.name)
        return newCurrentUser.avatar
    }
    
    func getNewName()-> String {
        return currentUser.name
    }
    func getNewAvatar()-> String{
        return currentUser.avatar
    }
    
    func setName(_ newName: String?){
        guard let newName = newName else {return}
        currentUser.name = newName
    }
    
    func setAvatar(_ newAvatar: String?){
        guard let newAvatar = newAvatar else {return}
        currentUser.avatar = newAvatar
    }
    
    
    func saveChanges(newName: String, newAvatar: String) throws {
        statusLoading = true
        currentUser.avatar = newAvatar
        currentUser.name = newName
        let _ = try reposytory.updateUser(user: currentUser)
    }
}
