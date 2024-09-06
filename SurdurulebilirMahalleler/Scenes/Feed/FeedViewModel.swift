//
//  FeedViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation
import FirebaseFirestore

class FeedViewModel: BaseViewModel {
    
    
    let network = Network.shared
    let auth = AuthManager.shared.auth
    
    var lastDoc: DocumentSnapshot?
    let limit = 4
    var isLoadAfterData = true
    
    func getInitPosts(_ closure: @escaping ([PostModel]?) -> Void ) {
        let ref = Network.shared.database.collection(FirebaseCollections.posts.rawValue)
        let query = ref.order(by: "timestamp", descending: true).limit(to: limit)
           
           gradientLoagingTabAnimation!.startAnimations()
           
           
           Network.shared.getMany(of: PostModel.self, with: query) { [weak self] (result: Result<([PostModel], DocumentSnapshot?), Error>) in
               guard let self else {return}
               
               switch result {
               case .success((let posts, let lastDoc)):
                   self.getPostUser(posts) { newPosts in
                       closure(newPosts)
                       self.lastDoc = lastDoc
                       self.isLoadAfterData = true
                   }
                   
               case .failure(let error):
                   closure(nil)
                   print("Hata: \(error)")
                   self.failAnimation?("Hata: \(error.localizedDescription)")

               }
               
               self.gradientLoagingTabAnimation?.stopAnimations()
           }
       }
    

    func getAfterPosts(_ closure: @escaping ([PostModel]?) -> Void ) {
        guard isLoadAfterData else {return}
        
        let ref = network.database.collection(FirebaseCollections.posts.rawValue)
        let query = ref.order(by: "timestamp", descending: true).limit(to: limit)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        
        network.getMany(lastDoc: lastDoc,of: PostModel.self, with: query) { [weak self] (result: Result<([PostModel],DocumentSnapshot?), Error>) in
            guard let self else {return}
            
            switch result {
            case .success((let posts, let newLastDoc)):
                
                guard !posts.isEmpty else {
                    self.isLoadAfterData = false
                    self.gradientLoagingTabAnimation?.stopAnimations()
                    closure(nil); return
                }
                
                self.getPostUser(posts) { newPosts in
                    self.lastDoc = newLastDoc
                    closure(newPosts)
                }
                
            case .failure(let error):
                closure(nil)
                print("Hata: \(error)")
                self.failAnimation?("Hata: \(error.localizedDescription)")
                self.isLoadAfterData = false

            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }

    
    private func getPostUser(_ posts: [PostModel], _ closure: @escaping ([PostModel]) ->Void) {
        let dispatchGroup = DispatchGroup()
        
        var updatedPosts = posts
        
        for i in 0..<posts.count {
            dispatchGroup.enter()
            let post = posts[i]
            
            guard let userRef = post.userReference else {
                dispatchGroup.leave()
                        continue
                    }
            
            Network.shared.getDocument(reference: userRef) { [weak self] (result: Result<UserModel, any Error>) in
                guard let self else {return}
                
                switch result {
                case .success(let user):
                    dispatchGroup.enter()
                    self.isItLikedPost(postId: post.id) { postLikeId in
                        
                        dispatchGroup.leave()
                        updatedPosts[i].userModel = user
                        guard let postLikeId else {return}
                        updatedPosts[i].postLikeId = postLikeId
                    }
                    
                case .failure(let error):
                    print("\n HATA: \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
                closure(updatedPosts)
        }
    }
    
    private func isItLikedPost(postId: String, _ closure: @escaping (String?) -> Void) {
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        let collectionStr = FirebaseCollections.postLikes.rawValue
        let collection = network.database.collection(collectionStr)
        let query = collection.whereField("userId", isEqualTo: currentUserId).whereField("postId", isEqualTo: postId)
        
        network.getOne(of: PostLikeModel.self, with: query) { (result: Result<PostLikeModel, any Error>)  in
            switch result {
            case .success(let data):
                closure(data.id)
            case .failure(let failure):
                closure(nil)
            }
        }
        
    }
    
    func sendLike(post: PostModel, _ closure: @escaping (_ likeId: String?) -> Void) {
        guard let currentUserId = auth.currentUser?.uid else {return}
        
        let likeModel = PostLikeModel(userId: currentUserId, postId: post.id)
        let likeModelRef = network.refCreate(collection: .postLikes, uid: likeModel.id)
        
        var newPost = post
        newPost.totalLike += 1
        newPost.postLikeId = nil
        
        let postModelRef = network.refCreate(collection: .posts, uid: post.id)
        
        let batch = network.database.batch()
        
        do {
            let likeDoc = try network.firestore.Encoder().encode(likeModel)
            let newPostDoc = try network.firestore.Encoder().encode(newPost)
            
            batch.setData(likeDoc, forDocument: likeModelRef)
            batch.updateData(newPostDoc, forDocument: postModelRef)
            
            batch.commit { error in
                if let error {
                    print("ERROR \(error.localizedDescription)")
                    closure(nil)
                } else {
                    closure(likeModel.id)
                }
            }
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
            closure(nil)
        }
        
    }
    
    func sendUnikePost(post: PostModel,likeId: String,_ closure: @escaping(Bool) -> Void) {
        
        let likeModelRef = network.refCreate(collection: .postLikes, uid: likeId)
        
        var newPost = post
        newPost.totalLike -= 1
        newPost.postLikeId = nil
        
        let postModelRef = network.refCreate(collection: .posts, uid: post.id)
        
        let batch = network.database.batch()
        
        do {
            let newPostDoc = try network.firestore.Encoder().encode(newPost)
            
            batch.deleteDocument(likeModelRef)
            batch.updateData(newPostDoc, forDocument: postModelRef)
            
            batch.commit { error in
                if let error {
                    print("ERROR \(error.localizedDescription)")
                    closure(false)
                } else {
                    closure(true)
                }
            }
        } catch let error {
            print("ERROR: \(error.localizedDescription)")
            closure(false)
        }
        
    }
}
