//
//  SignUpViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.04.2024.
//

import Foundation
import UIKit.UIViewController

class SignUpViewModel: BaseViewModel {
    
    func signUpWithGoogle(controller: UIViewController ,_ closure: @escaping (Bool) -> Void) {
        loadingAnimationStart?("please wait..")
        AuthManager.shared.withGoogleSession(controller: controller) { [weak self] (status, error) in
            guard let self else {return}
            if let error {
                self.failAnimation?("something went wrong\nerror Message: \(error.localizedDescription)")
                closure(false)
            } else if status {
                self.loadingAnimationStop?()
                closure(true)
            }
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
}
