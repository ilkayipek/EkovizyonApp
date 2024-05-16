//
//  CurrentUserProfileViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 4.05.2024.
//

import Foundation

class CurrentUserProfileViewModel: BaseViewModel {
    
    func getUsersPosts(_ closure: @escaping([PostModel]?) -> Void) {
        
        let userModel: UserModel? = UserInfo.shared.retrieve(key: .user)
        guard let userId = userModel?.id else {return}
        
        let network = Network.shared
        let collectionString = FirebaseCollections.posts.rawValue
        let collection = network.database.collection(collectionString)
        let userRef = network.refCreate(collection: .users, uid: userId)
        let query = collection.whereField("userReference", isEqualTo: userRef).order(by: "timestamp", descending: true)
        
        gradientLoagingTabAnimation?.startAnimations()
        
        network.getMany(of: PostModel.self, with: query) {[weak self] (result: Result<[PostModel], any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                guard !data.isEmpty else {self.gradientLoagingTabAnimation?.stopAnimations() ;closure(nil); return}
                
                //current user set to map in each posts.
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
            
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    func deletePost(_ postModel: PostModel, _ closure: @escaping(Bool) ->Void ) {
        
        loadingAnimationStart?("")
        Network.shared.delete(postModel, in: .posts) { [weak self] (result: (Result<Void, any Error>)) in
            guard let self else {return}
            
            switch result {
            case.success():
                
                //updates the user post count when process success.
                self.updateUserDetailPostCount { status in
                    guard status else {self.failAnimation?("kullanıcı detayı güncellenemedi"); closure(false) ;return}
                    
                    self.successAnimation?("Gönderi silme işlemi başarılı")
                    closure(true)
                }
            case .failure( let error):
                self.failAnimation?("Gönderi silme işlemi başarısız: \(error.localizedDescription)")
                closure(false)
            }
        }
    }
    
    private func updateUserDetailPostCount(_ closure: @escaping(Bool) -> Void) {
        
        let userDetail: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
        guard var userDetail else { closure(false) ;return}
        
        userDetail.totalPost -= 1
        
        Network.shared.put(userDetail, to: .userDetails) { [weak self] (result: Result<UserDetailModel, any Error>) in
            
            guard let self else {return}
            
            switch result {
            case .success(_):
                UserInfo.shared.store(key: .userDetail, value: userDetail)
                closure(true)
            case .failure(let failure):
                closure(false)
            }
        }
    }
    
    func getUserDetail(_ closure: @escaping(UserDetailModel?) -> Void) {
        
        guard let currentUserId = AuthManager.shared.auth.currentUser?.uid else {
            closure(nil); return
        }
        
        let ref = Network.shared.refCreate(collection: .userDetails, uid: currentUserId)
        
        Network.shared.getDocument(reference: ref) { (result: Result<UserDetailModel, any Error>) in
            
            switch result {
            case .success(let data):
                UserInfo.shared.store(key: .userDetail, value: data)
                closure(data)
            case .failure(let error):
                print(" Kullanıcı detayları getirme sırasında bir hata oluştu: \(error.localizedDescription)")
                closure(nil)
            }
        }
    }
}
