//
//  CurrentUserPostTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 5.05.2024.
//

import UIKit

class CurrentUserPostTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: CustomUIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var deletePostButton: UIButton!
    
    var deletePostButtonHandler: (() -> Void)?


    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func deletePostButtonClicked(_ sender: Any) {
        deletePostButtonHandler?()
    }
    
    
    func loadCell(_ postModel: PostModel) {
        guard let userModel = postModel.userModel else {return}
        nameLabel.text = userModel.name
        userNameLabel.text = "@\(userModel.username ?? "")"
        contentLabel.text = postModel.contentText
        likeButton.setTitle("\(postModel.totalLike)", for: .normal)
        commentsButton.setTitle("\(postModel.totalComment)", for: .normal)
       
        if let pofileImageUrl = URL(string: userModel.profileUrl ?? "") {
            profileImageView.loadImage(url: pofileImageUrl, placeHolderImage: nil, nil)
        }
        if let postContentUrl = URL(string: postModel.contentImageUrl ?? "") {
            contentImageView.isHidden = false
            contentImageView.loadImage(url: postContentUrl, placeHolderImage: nil, nil)
        } else {
            contentImageView.isHidden = true
        }
    }
    
}
