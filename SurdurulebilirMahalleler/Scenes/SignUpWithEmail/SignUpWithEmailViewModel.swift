//
//  SignUpWithEmailViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 22.04.2024.
//

import Foundation

class SignUpWithEmailViewModel : BaseViewModel{
    func signUp(_ fullName: String, _ email: String, _ password: String, _ closure: @escaping (Bool) -> Void) {
        
        if isValidEmail(email: email) {
            if validatePassword(password) {
                loadingAnimationStart?("Lütfen Bekleyin..")
                AuthManager.shared.signUpWithEmail(fullName, email, password) { [weak self] status, error in
                    guard let self else {return}
                    if let error {
                        self.failAnimation?("Bir Hata Oluştu!:\(error.localizedDescription)")
                        closure(false)
                    } else if status {
                        self.successAnimation?("Kayıt işlemi başarılı")
                        closure(true)
                    }
                }
            } else {
                failAnimation?("Şifreniz en az 8 karakter uzunluğunda olmalıdır ve en az bir büyük harf, bir küçük harf, bir sayı ve bir özel karakter içermelidir. Örneğin: Abcd1234!")
            }
        } else {
            failAnimation?("Lütfen geçerli bir Eposta giriniz.")
        }
        
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
