//
//  LoginViewModel.swift
//  Login_MVVM
//
//  Created by Oscar A. Rafael Cabanillas on 04/07/2024.
//

import Foundation
import Combine

class LoginViewModel {
    @Published var email = ""
    @Published var password = ""
    @Published var isEnable = false
    @Published var showLoading = false
    @Published var errorMessage = ""
    
    var cancellables = Set<AnyCancellable>()
    
    let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
        self.formValidation()
    }
    
    func formValidation(){
        Publishers.CombineLatest($email, $password)
            .filter { email, password in
                return email.count > 5 && password.count > 5
            }
            .sink { value in
                self.isEnable = true
            }.store(in: &cancellables)
        
        //        $email
        //            .filter { $0.count > 5 }
        //            .receive(on: DispatchQueue.main)
        //            .sink { value in
        //                self.isEnable = true
        //            print("Email: \(value)")
        //        }.store(in: &cancellables)
        //
        //        $password
        //            .filter { $0.count > 5 }
        //            .receive(on: DispatchQueue.main)
        //            .sink { value in
        //            print("Password: \(value)")
        //        }.store(in: &cancellables)
    }
    
    @MainActor
    func userLogin(withEmail email: String, password: String) {
        errorMessage = ""
        showLoading = true
        Task {
            do {
                let userModel = try await apiClient.login(withEmail: email, password: password)
            } catch let error as BackendError {
//                print(error.localizedDescription)
                errorMessage = error.rawValue
            }
            showLoading = false
        }
    }
}
