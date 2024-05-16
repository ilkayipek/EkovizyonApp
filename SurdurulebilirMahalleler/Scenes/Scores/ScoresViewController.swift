//
//  ScoresViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.05.2024.
//

import UIKit

class ScoresViewController: BaseViewController<ScoresViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScoresViewModel()
    }
}
