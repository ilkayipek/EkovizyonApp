//
//  EventsTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 28.04.2024.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var totalParticipantLabel: UILabel!
    @IBOutlet weak var eventPointButton: CustomUIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func loadCell(_ model: EventModel) {
        titleLabel.text = model.title
        dateLabel.text = model.date.description
        ownerNameLabel.text = model.ownerName
        totalParticipantLabel.text = "\(model.totalParticipant) katılımcı"
        eventPointButton.setTitle("\(model.point)", for: .normal)
        
        if let bannerImageUrl = URL(string: model.bannerImageUrl ?? "") {
            bannerImageView.loadImage(url: bannerImageUrl, placeHolderImage: nil, nil)
        }
    }
    
}
