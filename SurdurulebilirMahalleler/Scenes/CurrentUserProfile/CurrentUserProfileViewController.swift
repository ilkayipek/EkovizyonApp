//
//  CurrentUserProfileViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 4.05.2024.
//

import UIKit

class CurrentUserProfileViewController: BaseViewController<CurrentUserProfileViewModel> {
    @IBOutlet weak var profileTableView: UITableView!
    
    var userPosts = [PostModel]()
    var userDetail: UserDetailModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.title = "Profil"
        viewModel = CurrentUserProfileViewModel()
        
        getCurrentUserDetail()
        settingsButtonCreate()
        configureProfileTableView()
        getPageData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.title = "Profil"
        settingsButtonCreate()
    }
    
    private func configureProfileTableView() {
        profileTableView.dataSource = self
        profileTableView.dataSource = self
        
        let usrDetailCellString = String(describing: UserProfileTableViewCell.self)
        profileTableView.register(UINib(nibName: usrDetailCellString, bundle: nil), forCellReuseIdentifier: usrDetailCellString)
        
        let postCellString = String(describing: CurrentUserPostTableViewCell.self)
        profileTableView.register(UINib(nibName: postCellString, bundle: nil), forCellReuseIdentifier: postCellString)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        profileTableView.refreshControl = refreshControl
    }
    
    //MARK: Static current user detail get
    private func getCurrentUserDetail() {
        
        let currentUserDetail: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
        guard currentUserDetail != nil else {self.navigationController?.popViewController(animated: true);return}
        
        self.userDetail = currentUserDetail
    }
    
    private func settingsButtonCreate() {
        guard AuthManager.shared.auth.currentUser != nil else {return}
        
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "gearshape.fill"), style: .plain, target: self, action: #selector(settingsButtonClicked))
        settingsButton.image?.withTintColor(UIColor.activeButton)
        self.tabBarController?.navigationItem.rightBarButtonItem = settingsButton
    }
    
    //MARK: Buttons Action functions
    @objc func refreshData(_ sender: Any) {
        getPageData()
    }

    
    @objc func settingsButtonClicked() {
        let targetVc = SettingsViewController.loadFromNib()
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    //MARK: Get data from network
    private func getPageData(){
        viewModel?.getUserDetail() {[weak self] userDetail in
            guard let self else {return}
            guard let userDetail else {
                self.navigationController?.popViewController(animated: true)
                return
            }
            
            self.userDetail = userDetail
            self.profileTableView.reloadData()
        }
        
        viewModel?.getUsersPosts {[weak self] posts in
            guard let self else {return}
            
            self.profileTableView.refreshControl?.endRefreshing()
            
            guard let posts else {return}
            self.userPosts = posts
            self.profileTableView.reloadData()
        }
    }
    
    

}

extension CurrentUserProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPosts.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //set UserProfileTableViewCell in tableView first index
        switch indexPath.row {
        case 0:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: String(describing: UserProfileTableViewCell.self), for: indexPath) as! UserProfileTableViewCell
            guard let userDetail else {return UITableViewCell()}
            cell.loadCell(userDetail)
            
            return cell
            
        //set other cells as many posts
        case 1..<(userPosts.count + 1):
            
            let cell = profileTableView.dequeueReusableCell(withIdentifier: String(describing: CurrentUserPostTableViewCell.self), for: indexPath) as! CurrentUserPostTableViewCell
            
            guard !userPosts.isEmpty else {return UITableViewCell()}
            let postIndex = indexPath.row - 1
            let post = userPosts[postIndex]
            
            cell.loadCell(post)
            cell.deletePostButtonHandler = { [weak self] in
                guard let self else {return}
                
                self.alertMessageDefault("UYARI!", "Silmek İstediğinize Emin Misiniz?", "Sil") { _ in
                    self.deletePost(post, index: postIndex)
                }
            }
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    //MARK: the function run when get triggered deletePostButtonHandler from CurrentUserPostTableViewCell
    private func deletePost(_ post: PostModel, index: Int) {
        viewModel?.deletePost(post) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            
            self.userPosts.remove(at: index)
            self.getCurrentUserDetail()
            self.profileTableView.reloadData()
        }
    }
    
    
    
}

