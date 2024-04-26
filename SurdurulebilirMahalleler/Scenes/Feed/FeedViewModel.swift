//
//  FeedViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

class FeedViewModel: BaseViewModel {
    let dispatchGroup = DispatchGroup()
    
    func getPosts(_ closure: @escaping ([PostModel]?) -> Void ) {
        let ref = Network.shared.database.collection(FirebaseCollections.posts.rawValue)
        let query = ref.order(by: "timestamp", descending: true)
        
        gradientLoagingTabAnimation?.startAnimations()
        dispatchGroup.enter()
        Network.shared.getMany(of: PostModel.self, with: query) { [weak self] (result: Result<[PostModel], Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let posts):
                self.getPostUser(posts) { newPosts in
                    closure(newPosts)
                }
                
            case .failure(let error):
                closure(nil)
                print("Hata: \(error)")
                self.failAnimation?("Hata: \(error.localizedDescription)")

            }
            self.dispatchGroup.leave()
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    func getPostUser(_ posts: [PostModel], _ closure: @escaping ([PostModel]) ->Void) {
        
        var updatedPosts = posts
        
        for i in 0..<posts.count {
            dispatchGroup.enter()
            var post = posts[i]
            
            guard let userRef = post.userReference else {
                dispatchGroup.leave()
                        continue
                    }
            
            Network.shared.getDocument(reference: userRef) { [weak self] (result: Result<UserModel, any Error>) in
                guard let self else {return}
                
                switch result {
                case .success(let user):
                    updatedPosts[i].userModel = user
                case .failure(let error):
                    print("\n HATA: \(error.localizedDescription)")
                }
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
                closure(updatedPosts)
        }
    }
    
    func isItLikedPost(postId: String, _ closure: @escaping (Bool) -> Void) {
        
    }
    
    func sendLike(postId: String, userId: String, _ closure: @escaping (Bool) -> Void) {
        
    }
    
    func updatePost(_ postModel: PostModel) {
        
    }
    
    func closeDispatchGroup(_ closure: @escaping() ->Void) -> Void {
        dispatchGroup.notify(queue: .main) {
            closure()
        }
    }
}
