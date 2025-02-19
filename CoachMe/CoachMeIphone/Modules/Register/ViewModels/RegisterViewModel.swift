//
//  MainView.swift
//  CoachMe
//
//  Created by Vadim Timofeev on 06.02.2025.
//

import Foundation
import Combine

class RegisterViewModel{
    private let repository: RegisterRepositoryProtocol
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }
    func getRepository () -> RegisterRepositoryProtocol{
        return repository
    }
    func validateFields(name: String?, userName: String?, email: String?, password: String?, confirmPassword: String?, phone: String?, birthDate: String?, gender: String, status: String, coachCode: String?, gym: String) -> AnyPublisher<StatusRegister, Never>{
        guard let name = name,
              let userName = userName,
              let email = email,
              let password = password,
              let confirmPassword = confirmPassword,
              let birthDate = birthDate,
              let phone = phone else {
            return Just(.emptyFields).eraseToAnyPublisher()
        }
        guard let date = formateDate(birthDate) else {
            return Just(.ErrorFormatBirthDate).eraseToAnyPublisher()
        }
        guard isValidEmail(email) else {
            return Just(.IncorrectEmail).eraseToAnyPublisher()
        }
        guard password == confirmPassword else {
            return Just(.passwordMismatch).eraseToAnyPublisher()
        }
        
        guard let phoneNumber = formatPhoneNumber(phoneNumber: phone) else {
            return Just(.IncorrectPhoneNumber).eraseToAnyPublisher()
        }
        guard let currentGYM = UserModel.GYM(rawValue: gym) else{
            return Just(.errorCreateGYM).eraseToAnyPublisher()
        }
        let currentGender = gender == "male" ? UserModel.Gender.male : UserModel.Gender.female
        let newId = UUID()
        // Если статус — тренер, переходим в асинхронную ветку
        if status == StatusUserTrainer.trainer.rawValue {
            guard let coachCode = coachCode else {
                return Just(.absentCoachCode).eraseToAnyPublisher()
            }
            
            
            let newTrainer = TrainerModel(id: newId, coachCode: coachCode, userName: userName)
            let newUser = UserModel(
                        id: newId,
                        name: name,
                        avatar: "default_avatar",
                        progress: [],
                        status: UserModel.UserStatus.outGym,
                        email: email,
                        userName: userName,
                        phoneNumber: phoneNumber,
                        gender: currentGender,
                        birthday: date,
                        gym: currentGYM,
                        statusTrainer: 1 , password: password // статус тренера
                    )
            
            return repository.saveTrainer(newTrainer)
                .flatMap { _ in
                    return self.repository.saveUser(newUser)
                        .map {_ in StatusRegister.userCreate}
                        .catch{error -> Just<StatusRegister> in
                            if error == RegisterError.alreadyExists{
                                return Just(.userExist)
                            }else {
                                return Just(.errorCreate)
                            }
                        }
                }
                .catch{error -> Just<StatusRegister> in
                    if error == RegisterTrainer.coachCodeIncorrect{
                        return Just(.incorrectCoachCode)
                    }else {
                        return Just(.errorRegisterTrainer)
                    }
                }
                .eraseToAnyPublisher()
        } else {
            let newUser = UserModel(id: newId, name: name, avatar: "default_avatar", progress: [], status: UserModel.UserStatus.outGym, email: email, userName: userName, phoneNumber: phoneNumber, gender:currentGender , birthday: date, gym: currentGYM , statusTrainer: 0, password: password)
            return repository.saveUser(newUser)
                .map{_ in StatusRegister.userCreate}
                .catch{error -> Just<StatusRegister> in
                    if error == RegisterError.alreadyExists{
                        return Just(.userExist)
                    }else {
                        return Just(.errorCreate)
                    }}.eraseToAnyPublisher()
            
        }
    }
    
    func formatPhoneNumber(phoneNumber: String) -> String? {
          // Убираем все ненужные символы (не цифры)
        let newDrop = phoneNumber.replacingOccurrences(of: "\\D", with: "", options: .regularExpression)
          
          // Проверяем, что номер состоит из 11 цифр
          if newDrop.count == 11, newDrop.allSatisfy({ $0.isNumber }) {
              // Форматируем номер в международном формате: +7 (XXX) XXX-XX-XX
              let first = newDrop[newDrop.index(newDrop.startIndex, offsetBy: 1)..<newDrop.index(newDrop.startIndex, offsetBy: 4)]
              let second = newDrop[newDrop.index(newDrop.startIndex, offsetBy: 4)..<newDrop.index(newDrop.startIndex, offsetBy: 7)]
              let third = newDrop[newDrop.index(newDrop.startIndex, offsetBy: 7)..<newDrop.index(newDrop.startIndex, offsetBy: 9)]
              let fourth = newDrop[newDrop.index(newDrop.startIndex, offsetBy: 9)..<newDrop.index(newDrop.startIndex, offsetBy: 11)]
              
              // Форматируем телефон в формате +7 (XXX) XXX-XX-XX
              let formattedNumber = "+7 (\(first)) \(second)-\(third)-\(fourth)"
              return formattedNumber
          }
          return nil // Если номер не корректен
      }
    
    func isValidEmail(_ email: String) -> Bool {
        // Регулярное выражение для проверки корректности email
        let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func formateDate (_ dateString: String) -> Date?
    {
//        print(dateString)
        let dateFomatter = DateFormatter()
        
        dateFomatter.dateFormat = "dd.MM.yyyy"
        return dateFomatter.date(from: dateString)
        
            
    }
    
    enum StatusUserTrainer: String {
        case trainer = "Trainer"
        case notATrainer = "Not a Trainer"
    }
    
    enum StatusRegister {
        case userCreate
        case emptyFields
        case userExist
        case errorCreate
        case ErrorFormatBirthDate
        case IncorrectEmail
        case passwordMismatch
        case IncorrectPhoneNumber
        case absentCoachCode
        case incorrectCoachCode
        case errorRegisterTrainer
        case errorCreateGYM
    }
}
