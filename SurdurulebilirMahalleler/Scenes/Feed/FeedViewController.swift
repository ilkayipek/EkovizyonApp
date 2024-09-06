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
        self.tabBarController?.title = "Ana Sayfa"
        
        viewModel = FeedViewModel()
        configureTableView()
        getInitPosts()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.title = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Ana Sayfa"
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let stringCell = String(describing: FeedTableViewCell.self)
        tableView.register(UINib(nibName: stringCell, bundle: nil), forCellReuseIdentifier: stringCell)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func getInitPosts() {
        viewModel?.getInitPosts(){ [weak self] posts in
            guard let self else {return}
            self.tableView.refreshControl?.endRefreshing()
            
            guard let posts else {
                self.tableView.reloadData()
                return
            }
            
            self.posts = posts
            self.tableView.reloadData()
        }
    }
    
    private func getAfterPosts() {
        viewModel?.getAfterPosts(){ [weak self] posts in
            guard let self else {return}
            guard let posts else {
                self.tableView.reloadData()
                return
            }
            
            self.posts += posts
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadData() {
        getInitPosts()
    }
    
    @IBAction func postShareButtonClicked(_ sender: Any) {
        let targetVc = PostShareViewController.loadFromNib()
        self.navigationController?.pushViewController(targetVc, animated: true)
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
            cell.feedDelegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (posts.count - 1) {
            getAfterPosts()
        }
    }
    
}

extension FeedViewController: HomeFeedDelegate {
    func likePost(post: PostModel, _ closure: @escaping (String?) -> Void) {
        viewModel?.sendLike(post: post, closure)
    }
    
    func unlikePost(post: PostModel, _ closure: @escaping (Bool) -> Void) {
        guard let likeId = post.postLikeId else {return}
        viewModel?.sendUnikePost(post: post, likeId: likeId, closure)
    }
    
    func userSelected(_ userId: String) {
        guard userId != AuthManager.shared.auth.currentUser?.uid else {
            if let tabBar = self.tabBarController {
                tabBar.selectedIndex = 3
            }
            return
        }
        
        let targetVc = UserProfileViewController.loadFromNib()
        targetVc.userId = userId
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    func commentsSelected(_ postId: String) {
         
    }
    
    func updateCell(_ cell: FeedTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        guard let postModel = cell.postModel else {return}
        
        posts[indexPath.row] = postModel
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func imageSelected(_ image: UIImage?) {
        let targetVc = FullScreenImageViewController.loadFromNib()
        targetVc.image = image
        targetVc.modalPresentationStyle = .fullScreen
        present(targetVc, animated: true)
    }
    
    
}
