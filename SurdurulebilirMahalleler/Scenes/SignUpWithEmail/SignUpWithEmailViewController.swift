//
//  SignUpWithEmailViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 22.04.2024.
//

import UIKit

class SignUpWithEmailViewController: BaseViewController<SignUpWithEmailViewModel> {
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var againPaswordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignUpWithEmailViewModel()
        
    }

    @IBAction func createAccountClicked(_ sender: Any) {
        let password = passwordTextField.text ?? ""
        let againPassword = againPaswordTextField.text ?? ""
        let name = fullNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        
        if isPasswordEqual(password, againPassword) {
            viewModel?.signUp(name, email, password){ [weak self] status in
                guard let self else {return}
                
                if status {
                    self.successCreateAccount()
                }
            }
        } else {
            failAnimation(text: "şifreler uyuşmuyor!")
        }
        
    }
    
    @IBAction func existingAccountClicked(_ sender: Any) {
    }
    
    func successCreateAccount() {
        let targetVc = TabBarViewController.loadFromNib()
        targetVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    func isPasswordEqual(_ password: String, _ passwordAgain: String) ->Bool {
        guard password == passwordAgain else {return false }
        return true
    }
    
}
