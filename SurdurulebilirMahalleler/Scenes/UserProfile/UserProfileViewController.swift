//
//  UserProfileViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class UserProfileViewController: BaseViewController<UserProfileViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = UserProfileViewModel()
        
    }
}
