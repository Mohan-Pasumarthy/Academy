//
//  LoginViewModel.swift
//  GoldmanSacs
//
//  Created by Mohan Pasumarthy on 26/04/26.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage = ""
    @Published var invalidCred: Bool = false
    @Published var isDisabled: Bool = true
    @Published var showErrorAlert = false
    
    var cancellables = Set<AnyCancellable>()
    
    private var authProvider: AuthenticationProvider
    
    init(authProvider: AuthenticationProvider = AuthencationManager()) {
        self.authProvider = authProvider
        
        // Button state
        Publishers.CombineLatest($email, $password)
            .map { [weak self] email, password in
                guard let self = self else { return true }
                return !(self.isValidEmail(email) && self.isValidPassword(password))
            }
            .assign(to: \.isDisabled, on: self)
            .store(in: &cancellables)
    }
    
    func handleSignIn() async -> Bool {
        
        do {
            _ = try await authProvider.signIn(email: email, password: password)
            return true
        } catch AuthenticationError.invalidCredential {
            errorMessage = "Incorrect Email or Password. if you are a new user click 'OK' to sign up"
            showErrorAlert = true
            invalidCred = true
            return false
        } catch AuthenticationError.networkError {
            errorMessage = "Network Error. Please try again"
            showErrorAlert = true
            return false
        } catch {
            errorMessage = "unknown Error. Please try again"
            showErrorAlert = true
            return false
        }
        
        
    }
    
    func clearFields() {
        email = ""
        password = ""
    }
    
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
