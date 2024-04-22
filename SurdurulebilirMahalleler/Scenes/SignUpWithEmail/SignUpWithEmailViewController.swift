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
    }
    
    @IBAction func existingAccountClicked(_ sender: Any) {
    }
    
}
