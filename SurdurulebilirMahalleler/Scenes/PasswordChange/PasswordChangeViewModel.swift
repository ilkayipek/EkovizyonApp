//
//  PasswordChangeViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 3.06.2024.
//

import Foundation

class PasswordChangeViewModel: BaseViewModel {
    
    func passwordChange(_ currentPass: String?,_ newPass: String?,_ againPass: String?) {
        let authManager = AuthManager.shared
        guard let currentUser = authManager.auth.currentUser else {return}
        guard isPasswordOkey(currentPass, newPass, againPass) else {return}
        
        let credential = authManager.emailAuthProvider.credential(withEmail: currentUser.email ?? "", password: currentPass!)
        
        currentUser.reauthenticate(with: credential) {[weak self] _, error in
            guard let self else {return}
            guard error == nil else {
                self.failAnimation?("HATA: \(error!.localizedDescription)"); return
            }
            
            currentUser.updatePassword(to: newPass!) { error in
                
                
                self.successAnimation?("Güncelleme Başarılı.")
            }
        }
    }
    
    private func isPasswordOkey(_ currentPass: String?,_ pass: String?,_ againPass: String?) -> Bool {
        guard let currentPass,let pass, let againPass, !pass.isEmpty, !againPass.isEmpty, !currentPass.isEmpty else {
            failAnimation?("lütfen tüm alanları doldurunuz.."); return false
        }
        
        guard pass == againPass else {
            failAnimation?("Şifreler Uyuşmuyor"); return false
        }
        
        guard validatePassword(pass) else {
            failAnimation?("Şifreniz en az 8 karakter uzunluğunda olmalıdır ve en az bir büyük harf, bir küçük harf, bir sayı ve bir özel karakter içermelidir. Örneğin: Abcd1234!")
            return false
        }
        return true
        
    }
    
    private func validatePassword(_ password: String) -> Bool {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
}
