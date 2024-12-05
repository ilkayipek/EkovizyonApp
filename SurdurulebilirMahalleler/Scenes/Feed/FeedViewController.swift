//
//  FeedViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 4.04.2024.
//

import UIKit
import FirebaseFirestore
import FirebaseCore

class FeedViewController: BaseViewController<FeedViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let stringCell = String(describing: FeedTableViewCell.self)
        tableView.register(UINib(nibName: stringCell, bundle: nil), forCellReuseIdentifier: stringCell)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedTableViewCell.self), for: indexPath) as! FeedTableViewCell
        return cell
    }
    
    
    
}
