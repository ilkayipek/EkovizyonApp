//
//  PasswordChangeViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 3.06.2024.
//

import UIKit

class PasswordChangeViewController: BaseViewController<PasswordChangeViewModel> {
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var againPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PasswordChangeViewModel()
    }

    @IBAction func passwordChangeButtonClicked(_ sender: Any) {
        viewModel?.passwordChange(currentPassword.text, newPassword.text, againPassword.text)
    }
}
