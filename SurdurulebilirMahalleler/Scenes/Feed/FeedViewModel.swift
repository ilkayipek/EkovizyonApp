//
//  FeedViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

class FeedViewModel: BaseViewModel {
    
    func getPosts(_ closure: @escaping ([PostModel]?,[UserModel]?) -> Void ) {
        
        let ref = Network.shared.database.collection(FirebaseCollections.posts.rawValue)
        let query = ref.order(by: "timestamp", descending: true)
        var users = [UserModel]()
        
        gradientLoagingTabAnimation?.startAnimations()
        Network.shared.getMany(of: PostModel.self, with: query) { [weak self] (result: Result<[PostModel], Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let posts):
                
                for post in posts {
                    self.getPostUser(post.userReference?.documentID ?? " ") { user in
                        guard let user else {return}
                        users.append(user)
                        closure(posts,users)
                    }
                }
                
            case .failure(let error):
                closure(nil,nil)
                print("Hata: \(error)")
                self.failAnimation?("Hata: \(error.localizedDescription)")
            }
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    func getPostUser(_ userId: String, _ closure: @escaping (UserModel?) ->Void) {
        let ref = Network.shared.refCreate(collection: .users, uid: userId)
        
        Network.shared.getDocument(reference: ref) { (result: Result<UserModel?, any Error>) in
            switch result {
            case .success(let data):
                if let data {
                    closure(data)
                    print(data)
                } else {
                    closure(nil)
                }
                
            case .failure(let error):
                closure(nil)
                print(error)
            }
        }
    }
    
    func isItLikedPost(postId: String, _ closure: @escaping (Bool) -> Void) {
        
    }
    
    func sendLike(postId: String, userId: String, _ closure: @escaping (Bool) -> Void) {
        
    }
    
    func updatePost(_ postModel: PostModel) {
        
    }
}
