//
//  FirstThreeScoreTableViewCell.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 22.05.2024.
//

import UIKit

class FirstThreeScoreTableViewCell: UITableViewCell {
    @IBOutlet weak var firstPersonName: UILabel!
    @IBOutlet weak var secondPersonName: UILabel!
    @IBOutlet weak var thirdPersonName: UILabel!
    @IBOutlet weak var firstPersonUsername: UILabel!
    @IBOutlet weak var secondPersonUsername: UILabel!
    @IBOutlet weak var thirdPersonUsername: UILabel!
    @IBOutlet weak var firstPersonScore: UILabel!
    @IBOutlet weak var secondPersonScore: UILabel!
    @IBOutlet weak var thirdPersonScore: UILabel!
    @IBOutlet weak var firstPersonImageView: UIImageView!
    @IBOutlet weak var secondPersonImageView: UIImageView!
    @IBOutlet weak var thirdPersonImageView: UIImageView!
    @IBOutlet weak var firstPersonStackView: UIStackView!
    @IBOutlet weak var secondPersonStackView: UIStackView!
    @IBOutlet weak var thirdPersonStackView: UIStackView!
    
    var personSelectedDelegate: FirstThreeScoreDelegate?
    var models: [PointDetail?] = [nil,nil,nil]
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func loadCell(_ models: [PointDetail?]) {
        guard !models.isEmpty else {return}
        
        let loaders = [loadFirstPerson, loadSecondPerson, loadThirdPerson]
        
        for (index, model) in models.prefix(3).enumerated() {
            loaders[index](model)
            self.models[index] = model
        }
        addGestureRecognizerToPeople()
    }
    
    private func loadFirstPerson(_ model: PointDetail?){
        guard let model, let user = model.userModel else {
            firstPersonStackView.isHidden = true; return
        }
        firstPersonStackView.isHidden = false
        
        firstPersonName.text = user.name
        firstPersonUsername.text = user.username
        firstPersonScore.text = "\(model.totalScore)"
        
        firstPersonImageView.image = UIImage.person
        if let url = URL(string: user.profileUrl ?? "") {
            firstPersonImageView.loadImage(url: url, placeHolderImage: nil, nil)
        }
    }
    
    private func loadSecondPerson(_ model: PointDetail?){
        guard let model, let user = model.userModel else {
            secondPersonStackView.isHidden = true; return
        }
        secondPersonStackView.isHidden = false
        
        secondPersonName.text = user.name
        secondPersonUsername.text = "@\(user.username ?? "")"
        secondPersonScore.text = "\(model.totalScore)"
        
        secondPersonImageView.image = UIImage.image(from: .person)
        if let url = URL(string: user.profileUrl ?? "") {
            secondPersonImageView.loadImage(url: url, placeHolderImage: nil, nil)
        }
    }
    
    private func loadThirdPerson(_ model: PointDetail?){
        guard let model, let user = model.userModel else {
            thirdPersonStackView.isHidden = true; return
        }
        thirdPersonStackView.isHidden = false
        
        thirdPersonName.text = user.name
        thirdPersonUsername.text = user.username
        thirdPersonScore.text = "\(model.totalScore)"
        
        thirdPersonImageView.image = UIImage.image(from: .person)
        if let url = URL(string: user.profileUrl ?? "") {
            thirdPersonImageView.loadImage(url: url, placeHolderImage: nil, nil)
        }
    }
    
    private func addGestureRecognizerToPeople() {
        for index in models.indices {
            switch index {
            case 0:
                let gestureRecognizer = UITapGestureRecognizer()
                gestureRecognizer.addTarget(self, action: #selector(firstPersonSelected))
                firstPersonStackView.addGestureRecognizer(gestureRecognizer)
            
            case 1:
                let gestureRecognizer = UITapGestureRecognizer()
                gestureRecognizer.addTarget(self, action: #selector(secondPersonSelected))
                secondPersonStackView.addGestureRecognizer(gestureRecognizer)
                
            case 2:
                let gestureRecognizer = UITapGestureRecognizer()
                gestureRecognizer.addTarget(self, action: #selector(thirdPersonSelected))
                thirdPersonStackView.addGestureRecognizer(gestureRecognizer)
                
            default:
                break
            }
        }
        
    }
    
    @objc func firstPersonSelected() {
        guard !models.isEmpty, let user = models[0]?.userModel else {return}
        personSelectedDelegate?.personSelected(user.id)
    }
    
    @objc func secondPersonSelected() {
        guard !models.isEmpty, let user = models[1]?.userModel else {return}
        personSelectedDelegate?.personSelected(user.id)
    }
    
    @objc func thirdPersonSelected() {
        guard !models.isEmpty, let user = models[2]?.userModel else {return}
        personSelectedDelegate?.personSelected(user.id)
    }
    
}
