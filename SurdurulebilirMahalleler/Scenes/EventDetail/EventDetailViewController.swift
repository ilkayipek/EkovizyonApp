//
//  eventDetailViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import UIKit

class EventDetailViewController: BaseViewController<EventDetailViewModel> {
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentInfoLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var totalParticipantLabel: UILabel!
    @IBOutlet weak var pointAmount: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var joinButton: CustomUIButton!
    
    var eventModel: EventModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = EventDetailViewModel()
        
        if eventModel == nil {
            self.navigationController?.popViewController(animated: true)
            failAnimation(text: "Bir Hata Oluştu")
        }
        didYouAttendEvent()
        loadPage()
    }
    
    private func didYouAttendEvent() {
        guard let eventModel else {return}
        
        viewModel?.didYouAttendEvent(eventModel.id) {[weak self] status in
            guard let self else {return}
            joinButton.isHidden = false
            guard status else {return}
            joinButton.isEnabled = false
            joinButton.setTitle("Katıldınız", for: .normal)
        }
    }
    
    private func loadPage() {
        guard let eventModel else {return}
        
        if let url = URL(string: eventModel.bannerImageUrl ?? "") {
            bannerImageView.loadImage(url: url, placeHolderImage: nil, nil)
        }
        
        titleLabel.text = eventModel.title
        dateLabel.text = eventModel.date.description
        ownerNameLabel.text = eventModel.ownerName
        location.text = eventModel.adress
        contentInfoLabel.text = eventModel.infoText
        totalParticipantLabel.text = "\(eventModel.totalParticipant) Katılımcı"
        pointAmount.text = "\(eventModel.point)"
    }
    
    @IBAction func joinEventButtonClicked(_ sender: Any) {
        guard let eventModel else {return}
        
        viewModel?.joinEvent(eventModel.id) { [weak self] status in
            guard let self else {return}
            guard status else {return}
            self.joinButton.isEnabled = false
            self.joinButton.setTitle("Katıldınız", for: .normal)
        }
    }
}
