//
//  UserProfileViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import Foundation

class UserProfileViewModel: BaseViewModel {
    
    let dispatchGroup = DispatchGroup()
    
    func getUsersPost(userId: String, _ closure: @escaping([PostModel]?) -> Void) {
        let network = Network.shared
        let userRef = network.refCreate(collection: .users, uid: userId)
        
        gradientLoagingTabAnimation?.stopAnimations()
        
        network.getDocument(reference: userRef) {[weak self] (result: Result<UserModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                
                self.getPosts(userModel: data) { posts in
                    guard let posts else {return}
                    closure(posts)
                }
            case .failure(let error):
                print("Kullanıcı bilgilerini getirme sırasında bir hata oluşru: \(error.localizedDescription)")
                closure(nil)
            }
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    private func getPosts(userModel: UserModel, _ closure: @escaping([PostModel]?) -> Void) {
        
        let network = Network.shared
        let collectionString = FirebaseCollections.posts.rawValue
        let collection = network.database.collection(collectionString)
        let userRef = network.refCreate(collection: .users, uid: userModel.id)
        let query = collection.whereField("userReference", isEqualTo: userRef)
        
        network.getMany(of: PostModel.self, with: query) {[weak self] (result: Result<[PostModel], any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                guard !data.isEmpty else {closure(nil); return}
                
                let newData = data.map { item -> PostModel in
                    var newPost = item
                    newPost.userModel = userModel
                    return newPost
                }
                closure(newData)
            case .failure(let error):
                print("Kullanıcıya ait postları getirme sırasında bir hata oluşru: \(error.localizedDescription)")
                closure(nil)
            }
            
        }
    }
    
    func getUserDetailModel(userId: String, _ closure: @escaping(UserDetailModel?) -> Void) {
        let network = Network.shared
        let userRef = network.refCreate(collection: .userDetails, uid: userId)
        
        network.getDocument(reference: userRef) {[weak self] (result: Result<UserDetailModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                closure(data)
            case .failure(let error):
                print("Kullanıcı bilgilerini getirme sırasında bir hata oluşru: \(error.localizedDescription)")
                closure(nil)
            }
        }
    }
    
    func dispatchGroupClose(_ closure: @escaping() -> Void)  {
        dispatchGroup.notify(queue: .main) {
            closure()
        }
    }
}
