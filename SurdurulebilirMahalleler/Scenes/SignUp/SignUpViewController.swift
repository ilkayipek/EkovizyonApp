//
//  SignUpViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.04.2024.
//

import UIKit

class SignUpViewController: BaseViewController<SignUpViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = SignUpViewModel()
    }
    
    @IBAction func signUpWithGoogleClicked(_ sender: Any) {
        viewModel?.signUpWithGoogle(controller: self) { [weak self] result in
            guard let self else {return}
            guard result else {return}
            self.successSignUp()
        }
    }
    @IBAction func signUpWithEmailClicked(_ sender: Any) {
        transitionSignUpWithEmailVc()
    }
    
    func successSignUp() {
        let targetVc = TabBarViewController.loadFromNib()
        targetVc.modalPresentationStyle = .fullScreen
        self.present(targetVc, animated: true)
    }
    
    func transitionSignUpWithEmailVc() {
        let targetVc = SignUpWithEmailViewController.loadFromNib()
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    @IBAction func existingAccountClicked(_ sender: Any) {
    }
}
