//
//  MainView.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

class RegisterViewModel{
    private let repository: RegisterRepositoryProtocol
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    func getRepository () -> RegisterRepositoryProtocol{
        return repository
    }
    func validateFields (userName: String?, email: String?, password: String?, confirmPassword: String?, phone: String?, birthDate: String?, gender: String, status: String, coachCode: String?) -> Bool{
        return true
    }
}
