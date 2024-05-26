//
//  FeedTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 22.04.2024.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: CustomUIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var userStackView: UIStackView!
    
    var feedDelegate: HomeFeedDelegate?
    var postModel: PostModel?
    var contentTextToggle = false

    override func awakeFromNib() {
        super.awakeFromNib()
        contentTextToggle = false
    }
    
    func loadCell(_ postModel: PostModel) {
        guard let userModel = postModel.userModel else {return}
        self.postModel = postModel
        
        nameLabel.text = userModel.name
        userNameLabel.text = "@\(userModel.username ?? "")"
        contentLabel.text = postModel.contentText
        likeButton.setTitle("\(postModel.totalLike)", for: .normal)
        commentsButton.setTitle("\(postModel.totalComment)", for: .normal)
       
        loadImages(profileUrl: userModel.profileUrl, contentUrl: postModel.contentImageUrl)
        loadLikeButton(likeId: postModel.postLikeId)
        
        addGestureRecognizers()
    }
    
    private func loadImages(profileUrl: String?, contentUrl: String?) {
        
        profileImageView.image = UIImage.image(from: .person)
        if let pofileImageUrl = URL(string: profileUrl ?? "") {
            profileImageView.loadImage(url: pofileImageUrl, placeHolderImage: nil, nil)
        }
        
        if let postContentUrl = URL(string: contentUrl ?? "") {
            contentImageView.isHidden = false
            contentImageView.loadImage(url: postContentUrl, placeHolderImage: nil, nil)
        } else {
            contentImageView.isHidden = true
        }
    }
    
    private func loadLikeButton(likeId: String?) {
        let defaultImage = UIImage(systemName: SystemImageName.like.rawValue)
        likeButton.setImage(defaultImage, for: .normal)
        
        guard likeId != nil else {return}
        
        let fillImage = UIImage(systemName: SystemImageName.likefill.rawValue)?.withTintColor(UIColor.activeButton)
        likeButton.setImage(fillImage, for: .normal)
        
    }
    
    func addGestureRecognizers() {
        let gestureRecognizerImage = UITapGestureRecognizer()
        gestureRecognizerImage.addTarget(self, action: #selector(imageSelected))
        contentImageView.addGestureRecognizer(gestureRecognizerImage)
        
        let gestureRecognizerUser = UITapGestureRecognizer()
        gestureRecognizerUser.addTarget(self, action: #selector(userSelected))
        userStackView.addGestureRecognizer(gestureRecognizerUser)
        
        let gestureRecognizerContentText = UITapGestureRecognizer()
        gestureRecognizerContentText.addTarget(self, action: #selector(contentTextClicked))
        contentLabel.addGestureRecognizer(gestureRecognizerContentText)
    }
    
    @objc func contentTextClicked() {
        if !contentTextToggle {
            contentLabel.numberOfLines = 0
            contentTextToggle = true
        } else {
            contentLabel.numberOfLines = 3
            contentTextToggle = false
        }
        
        feedDelegate?.cellReloadSize(self)
    }
    
    @objc func imageSelected() {
        feedDelegate?.imageSelected(contentImageView.image)
    }
    
    @objc func userSelected() {
        
        guard let id = postModel?.userModel?.id else {return}
        feedDelegate?.userSelected(id)
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        
        guard let postModel else {return}
        
        if postModel.postLikeId != nil {
            unlikePost(post: postModel)
        } else {
            likePost(post: postModel)
        }
    }
    
    private func unlikePost(post: PostModel) {
        feedDelegate?.unlikePost(post: post) {[weak self] status in
            guard let self else {return}
            guard status else {return}
        
            let likedImage = UIImage(systemName: SystemImageName.like.rawValue)
            self.likeButton.setImage(likedImage, for: .normal)
            self.postModel?.postLikeId = nil
            self.postModel?.totalLike -= 1
            self.feedDelegate?.updateCell(self)
    }
        
    }
    
    private func likePost(post: PostModel) {
        
        feedDelegate?.likePost(post: post) { [weak self] likeId in
            guard let self else {return}
            guard let likeId else {return}
            
            self.postModel?.postLikeId = likeId
            self.postModel?.totalLike += 1
            self.feedDelegate?.updateCell(self)
            self.likeButtonChange()
        }
    }
    
    private func likeButtonChange() {
        let likedImage = UIImage(systemName: SystemImageName.likefill.rawValue)
        
        self.likeButton.setImage(likedImage, for: .normal)
        self.likeButton.tintColor = .activeButton
    }
    
    
    @IBAction func commentButtonClicked(_ sender: Any) {
        
    }
}
