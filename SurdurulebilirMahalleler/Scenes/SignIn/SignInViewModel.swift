//
//  SignInViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 23.04.2024.
//

import Foundation
import UIKit.UIViewController

class SignInViewModel: BaseViewModel {
    func signInWithEmail(_ email: String, _ password: String, _ closure: @escaping (Bool) -> Void) {
        loadingAnimationStart?("")
        AuthManager.shared.signInWithEmail(email, password) {[weak self] status, error in
            guard let self else {return}
            
            if let error {
                self.failAnimation?("Hata: \(error.localizedDescription)")
                closure(false)
            } else if status {
                closure(true)
                self.loadingAnimationStop?()
            } else {
                self.failAnimation?("Bilinmeyen Bir hata Oluştu")
                closure(false)
            }
        }
    }

    func signInWithGoogle(controller: UIViewController, _ closure: @escaping (Bool) -> Void) {
        loadingAnimationStart?("")
        
        AuthManager.shared.withGoogleSession(controller: controller) { [weak self] status, error in
            guard let self else {return}
            
            if let error {
                self.failAnimation?("Hata: \(error.localizedDescription)")
                closure(false)
            } else if status{
                closure(true)
            } else {
                self.failAnimation?("Bilinmeyen bir hata oluştu")
            }
        }
    }
    
    func forgetMyPassword(_ email: String?)  {
        guard let email else {failAnimation?("email adresinizi giriniz.."); return}
        guard isValidEmail(email: email) else {
            failAnimation?("e postanız uygun formatta değil") ; return
        }
        
        AuthManager.shared.auth.sendPasswordReset(withEmail: email) {[weak self] error in
            guard let self else {return}
            
            if let error {
                self.failAnimation?("Hata: \(error.localizedDescription)")
            } else {
                self.successAnimation?("Şifte yenileme linki e postanıza gönderildi")
            }
            
        }
    }
    
    private func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
