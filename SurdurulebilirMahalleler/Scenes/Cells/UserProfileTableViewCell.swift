//
//  UserProfileTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalVizitedLocation: UILabel!
    @IBOutlet weak var totalAttendedEvents: UILabel!
    @IBOutlet weak var totalPostLabel: UILabel!
    @IBOutlet weak var profileImageView: CustomUIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(_ model: UserDetailModel) {
        name.text = model.fullName
        username.text = "@\(model.username ?? "")"
        totalPostLabel.text = "\(model.totalPost)"
        totalAttendedEvents.text = "\(model.totalAttendedEvents)"
        totalAttendedEvents.text = "\(model.totalAttendedEvents)"
        
        if let url = URL(string: model.profileImageUrl ?? "") {
            profileImageView.loadImage(url: url, placeHolderImage: nil, nil)
        }
    }
    
}
