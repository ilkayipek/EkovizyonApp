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
}
