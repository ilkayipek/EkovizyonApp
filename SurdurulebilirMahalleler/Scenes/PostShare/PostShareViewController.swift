//
//  PostShareViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 24.04.2024.
//

import UIKit
import PhotosUI

class PostShareViewController: BaseViewController<PostShareViewModel> {
    @IBOutlet weak var profileImage: CustomUIImageView!
    @IBOutlet weak var contentImageView: CustomUIImageView!
    @IBOutlet weak var contentTextView: CustomUITextView!
    var currentUser: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PostShareViewModel()
        postButtonCreate()
        currentUser = UserInfo.shared.retrieve(key: .user)
        loadCurrentUserImage()
    }
    
    @IBAction func selectImageButtonClicked(_ sender: Any) {
        selectImage()
    }
    @IBAction func clearImageButtonClicked(_ sender: Any) {
        contentImageView.image = nil
        contentImageView.isHidden = true
    }
    
    func postButtonCreate() {
        let postButton = UIBarButtonItem(image: UIImage(systemName: "paperplane.fill"), style: .plain, target: self, action: #selector(postButtonClicked))
        postButton.image?.withTintColor(UIColor.activeButton)
        navigationItem.rightBarButtonItem = postButton
    }
    
    @objc func postButtonClicked() {
        let contentText = contentTextView.text ?? ""
        let contentImage = contentImageView.image
        
        
        if contentImage  == nil ,contentText.isEmpty {
            failAnimation(text: "bir görsel veya yazı eklenmeli")
        } else {
            sharePost(contentText, contentImage)
        }
    }
    
    private func sharePost(_ contentText: String,_ image: UIImage?) {
        guard let currentUser else {return}
        
        viewModel?.createPost(contentText,image,currentUser.id) { [weak self] result in
            guard let self else {return}
            
            switch result {
            case .success(let status):
                self.transitToFeedVc()
            case .failure(let error): break
            }
        }
    }
    
    private func transitToFeedVc() {
        let targetVc = TabBarViewController.loadFromNib()
        targetVc.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(targetVc, animated: true)
    }
    
    private func loadCurrentUserImage() {
        if let currentUser , let profileImageUrl = URL(string: currentUser.profileUrl ?? "") {
            profileImage.loadImage(url: profileImageUrl, placeHolderImage: nil, nil)
        }
    }
    
    private func selectImage() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images // Yalnızca fotoğrafları filtrele
        configuration.selectionLimit = 1 // En fazla bir fotoğraf seçilmesine izin ver
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
}

extension PostShareViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = results.first else { return }
        
        selectedImage.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let self else {return}
                
                if let error = error {
                    print("Error picking image: \(error.localizedDescription)")
                } else if let image = image as? UIImage {
                    self.contentImageView.image = image
                    self.contentImageView.isHidden = false
                }
            }
        }
    }
    
    func pickerDidCancel(_ picker: PHPickerViewController) {
            picker.dismiss(animated: true, completion: nil)
        }
    
}
