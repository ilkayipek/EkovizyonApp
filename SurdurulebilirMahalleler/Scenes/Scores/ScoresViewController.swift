//
//  ScoresViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.05.2024.
//

import UIKit

class ScoresViewController: BaseViewController<ScoresViewModel> {
    @IBOutlet weak var scoreListTableView: UITableView!
    
    var scoreList = [PointDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScoresViewModel()
        self.tabBarController?.title = "Skor"
        
        configureTableView()
        getSceneData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.title = ""
    }
    
    private func configureTableView() {
        scoreListTableView.dataSource = self
        scoreListTableView.delegate = self
        
        let cellString = String(describing: ScoresTableViewCell.self)
        scoreListTableView.register(UINib(nibName: cellString, bundle: nil), forCellReuseIdentifier: cellString)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadScoreList(_:)), for: .valueChanged)
        scoreListTableView.refreshControl = refreshControl
    }
    
    private func getSceneData() {
        viewModel?.getScores{ [weak self] scores in
            guard let self else {return}
            guard let scores else {return}
            
            self.scoreListTableView.refreshControl?.endRefreshing()
            self.scoreList = scores
            self.scoreListTableView.reloadData()
        }
    }
    
    private func transitToUserDetail(_ userId: String) {
        guard userId != AuthManager.shared.auth.currentUser?.uid else {
            if let tabBar = self.tabBarController {
                tabBar.selectedIndex = 4
            }
            return
        }
        
        let targetVc = UserProfileViewController()
        targetVc.userId = userId
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    @objc func reloadScoreList(_ sender: Any) {
        getSceneData()
    }
}

extension ScoresViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoreList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scoreListTableView.dequeueReusableCell(withIdentifier: String(describing: ScoresTableViewCell.self), for: indexPath) as! ScoresTableViewCell
        
        let score = scoreList[indexPath.row]
        cell.loadCell(score, scoreNumber: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectedUserId = scoreList[indexPath.row].userModel?.id else {return}
        transitToUserDetail(selectedUserId)
    }
    
}
