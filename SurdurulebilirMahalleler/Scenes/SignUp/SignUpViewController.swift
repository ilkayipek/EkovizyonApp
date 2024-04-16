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
}
