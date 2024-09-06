//
//  UserProfileViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class UserProfileViewController: BaseViewController<UserProfileViewModel> {
    @IBOutlet weak var profileTableView: UITableView!
    
    var userId: String?
    var userPosts = [PostModel]()
    var userModel: UserModel?
    var userDetail: UserDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profil"
        guard userId != nil else {self.navigationController?.popViewController(animated: true);return}
        viewModel = UserProfileViewModel()
        configureProgileTableView()
        getPageData()
    }
    
    private func configureProgileTableView() {
        profileTableView.dataSource = self
        profileTableView.dataSource = self
        
        let usrDetailCellString = String(describing: UserProfileTableViewCell.self)
        profileTableView.register(UINib(nibName: usrDetailCellString, bundle: nil), forCellReuseIdentifier: usrDetailCellString)
        
        let postCellString = String(describing: FeedTableViewCell.self)
        profileTableView.register(UINib(nibName: postCellString, bundle: nil), forCellReuseIdentifier: postCellString)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        profileTableView.refreshControl = refreshControl
        
    }
    
    //MARK: Buttons Action functions
    @objc func refreshData(_ sender: Any) {
        getPageData()
    }
    
    private func getPageData() {
        
        viewModel?.getUsersPost(userId: userId!) { [weak self] posts in
            guard let self else {return}
            guard let posts else {return}
            
            self.userPosts = posts
            self.profileTableView.reloadData()
        }
        
        viewModel?.getUserDetailModel(userId: userId!) {[weak self] userDetail in
            guard let self else {return}
            self.userDetail = userDetail
            self.profileTableView.reloadData()
        }
    }
}

extension UserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: String(describing: UserProfileTableViewCell.self), for: indexPath) as! UserProfileTableViewCell
            guard let userDetail else {return UITableViewCell()}
            cell.loadCell(userDetail)
            return cell
        case 1..<(userPosts.count + 1):
            
            let cell = profileTableView.dequeueReusableCell(withIdentifier: String(describing: FeedTableViewCell.self), for: indexPath) as! FeedTableViewCell
            guard !userPosts.isEmpty else {return UITableViewCell()}
            let post = userPosts[indexPath.row - 1]
            cell.loadCell(post)
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
}
