//
//  eventDetailViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class EventDetailViewController: BaseViewController<EventDetailViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventDetailViewModel()
    }
}
