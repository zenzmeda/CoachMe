//
//  EditProfileViewModel.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 09.02.2025.
//
import Foundation

class EditProfileViewModel {
    private var reposytory: UserReposytoryProtocol
    
    init(reposytory: UserReposytoryProtocol) {
        self.reposytory = reposytory
    }
    
    var userName: String {
        return reposytory.fetchUser().name
    }
    
    var userAvatar: String {
        return reposytory.fetchUser().avatar
    }

  

    func saveChanges(newName: String, newAvatar: String) {
        let myprogress: [Stats] = []
        let user = UserModel(id: UUID(), name: "Vadim", avatar: "default_avatar", progress: [], status: .outGym,email: "dafult", userName: "default", phoneNumber: "default", gender: UserModel.Gender.male, birthday: Date(), gym: UserModel.GYM.KrasnyiProspect)
        reposytory.updateUser(user)
    }
}
