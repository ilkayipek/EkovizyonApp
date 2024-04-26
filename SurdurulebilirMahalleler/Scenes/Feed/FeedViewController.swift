//
//  FeedViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 4.04.2024.
//

import UIKit

class FeedViewController: BaseViewController<FeedViewModel> {
    
    @IBOutlet weak var tableView: UITableView!
    var posts = [PostModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        configureTableView()
        getPosts()
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let stringCell = String(describing: FeedTableViewCell.self)
        tableView.register(UINib(nibName: stringCell, bundle: nil), forCellReuseIdentifier: stringCell)
    }
    
    private func getPosts() {
        viewModel?.getPosts(){ [weak self] posts in
            guard let self else {return}
            guard let posts else {return}
            
            self.posts = posts
            self.tableView.reloadData()
        }
        
    }
    @IBAction func postShareButtonClicked(_ sender: Any) {
        let targetVc = PostShareViewController.loadFromNib()
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    @IBAction func SignOutClicked(_ sender: Any) {
        let auth = AuthManager.shared.auth
        do {
            try auth.signOut()
        } catch {
            print("çıkış başarısız")
        }
    }
    
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FeedTableViewCell.self), for: indexPath) as! FeedTableViewCell
        
        if !posts.isEmpty {
            let post = posts[indexPath.row]
            cell.loadCell(post)
        }
        
        return cell
    }
    
    
    
}
