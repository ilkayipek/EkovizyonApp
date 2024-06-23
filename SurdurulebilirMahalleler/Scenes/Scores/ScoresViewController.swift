//
//  ScoresViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.05.2024.
//

import UIKit

class ScoresViewController: BaseViewController<ScoresViewModel> {
    @IBOutlet weak var scoreListTableView: UITableView!
    
    var firstThreeScoreList = [PointDetail?]()
    var otherScoreList = [PointDetail]()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ScoresViewModel()
        self.tabBarController?.title = "Skor"
        
        configureTableView()
        getSceneData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Skor"
    }
    
    private func configureTableView() {
        scoreListTableView.dataSource = self
        scoreListTableView.delegate = self
        
        var cellString = String(describing: ScoresTableViewCell.self)
        scoreListTableView.register(UINib(nibName: cellString, bundle: nil), forCellReuseIdentifier: cellString)
        
        cellString = String(describing: FirstThreeScoreTableViewCell.self)
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
            self.firstThreeScoreList = Array(scores.prefix(3))
            self.otherScoreList = Array(scores.dropFirst(3))
            self.scoreListTableView.reloadData()
        }
    }
    
    private func transitToUserDetail(_ userId: String) {
        guard userId != AuthManager.shared.auth.currentUser?.uid else {
            if let tabBar = self.tabBarController {
                tabBar.selectedIndex = 3
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
        return otherScoreList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        switch index {
        case 0:
            let cell = scoreListTableView.dequeueReusableCell(withIdentifier: String(describing: FirstThreeScoreTableViewCell.self), for: indexPath) as! FirstThreeScoreTableViewCell
            
            cell.personSelectedDelegate = self
            cell.loadCell(firstThreeScoreList)
            return cell
            
        default:
            let cell = scoreListTableView.dequeueReusableCell(withIdentifier: String(describing: ScoresTableViewCell.self), for: indexPath) as! ScoresTableViewCell
            
            let score = otherScoreList[index - 1]
            cell.loadCell(score, scoreNumber: index + 3)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != 0 else {return}
        guard let selectedUserId = otherScoreList[indexPath.row - 1].userModel?.id else {return}
        transitToUserDetail(selectedUserId)
    }
    
}

extension ScoresViewController: FirstThreeScoreDelegate {
    
    func personSelected(_ userId: String) {
        transitToUserDetail(userId)
    }
}
