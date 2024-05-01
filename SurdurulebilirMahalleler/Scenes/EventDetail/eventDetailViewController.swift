//
//  eventDetailViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class eventDetailViewController: BaseViewController<EventDetailViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventDetailViewModel()
    }
}
