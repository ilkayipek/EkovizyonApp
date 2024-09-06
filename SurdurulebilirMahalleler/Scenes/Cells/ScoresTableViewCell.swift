//
//  ScoresTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.05.2024.
//

import UIKit

class ScoresTableViewCell: UITableViewCell {
    @IBOutlet weak var scoreNumber: UILabel!
    @IBOutlet weak var userFullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var userImage: CustomUIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(_ model: PointDetail, scoreNumber: Int) {
        self.scoreNumber.text = "\(scoreNumber)"
        self.userFullName.text = model.userModel?.name
        self.totalScore.text = "\(model.totalScore)"
        self.username.text = "@\(model.userModel?.username ?? "")"
        
        self.userImage.image = UIImage.image(from: .person)
        guard let url = URL(string: model.userModel?.profileUrl ?? "") else {return}
        self.userImage.loadImage(url: url, placeHolderImage: nil, nil)
    }
    
}
