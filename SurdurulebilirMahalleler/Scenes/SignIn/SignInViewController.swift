//
//  SignInViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 23.04.2024.
//

import UIKit

class SignInViewController: BaseViewController<SignInViewModel> {
    @IBOutlet weak var epostaTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignInViewModel()
    }

    @IBAction func signInButtonClicked(_ sender: Any) {
        if checkIsEmptyTextfields() {
            viewModel?.signInWithEmail(epostaTextField.text!, passwordTextField.text!) {[weak self] status in
                guard status else {return}
                guard let self else {return}
                self.successSignIn()
            }
        }
    }
    
    @IBAction func signInWithGoogleButtonClicked(_ sender: Any) {
        
        viewModel?.signInWithGoogle(controller: self) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            self.successSignIn()
        }
    }
    @IBAction func iForgetMyPasswordButtonClicked(_ sender: Any) {
    }
    
    func checkIsEmptyTextfields() -> Bool{
        if epostaTextField.text != "", passwordTextField.text != "" {
            return true
        } else {
            failAnimation(text: "Eposta ve şifre boş bırakılamaz")
            return false
        }
    }
    
    func successSignIn() {
        successAnimation(text: "Giriş Başarılı")
    }
}
