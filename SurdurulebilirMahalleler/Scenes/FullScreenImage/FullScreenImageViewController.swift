//
//  FullScreenImageViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 27.05.2024.
//

import UIKit

class FullScreenImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadImage()
    }
    
    func loadImage() {
        imageView.image = image
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        imageView.image = nil
        dismiss(animated: true)
    }
    
}
