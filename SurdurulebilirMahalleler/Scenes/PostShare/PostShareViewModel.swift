//
//  PostShareViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 24.04.2024.
//

import Foundation
import UIKit.UIImage

class PostShareViewModel: BaseViewModel {
    func createPost(_ contentText: String,_ contentImage: UIImage?, _ userId: String, _ closure: @escaping(Result<Bool, Error>) -> Void) {
        loadingAnimationStart?("Gönderi Paylaşılıyor..")
        let userRef = Network.shared.refCreate(collection: .users, uid: userId)
        var post = PostModel(userReference: userRef, contentText: contentText)
        
        loadContentImage(contentImage) { [weak self] url, error in
            guard let self = self else { return }
            
            if let error {
                self.failAnimation?("HATA: \(error.localizedDescription)")
                closure(.failure(error))
            } else if let url = url {
                post.contentImageUrl = url.absoluteString
            }
            
            Network.shared.post(post, to: .posts) { (result: Result<PostModel, Error>) in
                switch result {
                case .success(_):
                    
                    self.updatePostCount { status in
                        guard status else { self.failAnimation?("paylaşım sırasında bir hata oluştu"); return}
                        self.successAnimation?("Paylaşım Başarılı")
                        closure(.success(true))
                    }
                    
                case .failure(let error):
                    self.loadingAnimationStop?()
                    self.failAnimation?("Hata: \(error.localizedDescription)")
                    closure(.failure(error))
                }
            }
        }
    }

    
    private func loadContentImage(_ image: UIImage?, _ closure: @escaping(URL?, Error?) -> Void) {
        guard let image else {
            closure(nil, nil)
            return
        }
        
        image.upload(to: .postImages, withName: UUID().uuidString) { (result: Result<URL, any Error>) in
            switch result {
            case .success(let url):
                closure(url, nil)
            case .failure(let error):
                self.failAnimation?("Hata: \(error.localizedDescription)")
                closure(nil, error)
            }
        }
    }
    
    private func updatePostCount(_ closure: @escaping(Bool) -> Void) {
        let userDetail: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
        guard var userDetail else {closure(false); return}
        
        userDetail.totalPost += 1
        
        Network.shared.put(userDetail, to: .userDetails) { [weak self] (result: Result<UserDetailModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(_):
                UserInfo.shared.store(key: .userDetail, value: userDetail)
                closure(true)
            case .failure(let error):
                print("post sayısını güncelleme sırasında bir hata oluştu")
                closure(false)
            }
        }
    }
}
