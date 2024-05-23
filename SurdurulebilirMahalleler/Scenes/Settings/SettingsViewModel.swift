//
//  SettingsViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 7.05.2024.
//

import Foundation
import UIKit.UIImage

class SettingsViewModel: BaseViewModel {
    
    let userModel: UserModel? = UserInfo.shared.retrieve(key: .user)
    let userDetailModel: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
    
    //Updating all collections linked to the user
    func updateUserInfos(_ userDetail: UserDetailModel,_ image: UIImage,_ closure: @escaping(Bool) -> Void) {
        
        guard var newUserModel = userModel else {
            failAnimation?("")
            closure(false) ;return
        }
        
        guard let newUsername = userDetail.username, !newUsername.contains(" ") else {
            failAnimation?("Kullanıdı adı boşluk içermemeli.")
            closure(false); return
        }
        
        loadingAnimationStart?("Bilgiler Güncelleniyor..")
        
        uploadProfileImage(image, userDetail.profileImageId) { [weak self] status, url in
            guard let url , status else {closure(false); return}
            guard let self else {closure(false); return}
            
            newUserModel.profileUrl = url.absoluteString
            newUserModel.name = userDetail.fullName
            newUserModel.username = newUsername
            
            self.isUserNameUsed(userId: userModel?.id ?? "",newUsername: newUsername) { status in
                guard !status else {closure(false); return}
                
                self.updataUserModel(newUserModel) { status in
                    guard status else {closure(false); return}
                    
                    var newUserDetail = userDetail
                    newUserDetail.profileImageUrl = url.absoluteString
                    
                    self.updataUserDetailModel(newUserDetail) { status in
                        guard status else {closure(false); return}
                        
                        UserInfo.shared.store(key: .user, value: newUserModel)
                        UserInfo.shared.store(key: .userDetail, value: newUserDetail)
                        
                        self.successAnimation?("Kullanıcı Bilgileni Güncelleme başarılı")
                        closure(true)
                    }
                }

            }
        }
        
    }
    
    //image upload in network storage
    private func uploadProfileImage(_ image: UIImage,_ imageId: String,_ closure: @escaping(Bool, URL?) -> Void) {
        image.upload(to: .profileImages, withName: imageId) { [weak self] (result: Result<URL, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let url):
                closure(true, url)
            case .failure(let failure):
                failAnimation?("Fotoğraf Yükleme Sırasında Bir Hata Oluştu")
                closure(false, nil)
            }
        }
    }
    
    //update user model collection
    private func updataUserModel(_ user: UserModel,_ closure: @escaping(Bool) -> Void) {
        
        Network.shared.put(user, to: .users) { [weak self] (result: Result<UserModel, any Error>) in
            guard let self else {closure(false); return}
            
            switch result {
            case .success(_):
                closure(true)
            case .failure(let error):
                self.failAnimation?("HATA: \(error.localizedDescription)")
                closure(false)
            }
        }
    }
    
    //update user detail model collection
    private func updataUserDetailModel(_ userDetail: UserDetailModel,_ closure: @escaping(Bool) -> Void) {
        
        Network.shared.put(userDetail, to: .userDetails) {[weak self] (result: Result<UserDetailModel, any Error>) in
            guard let self else {closure(false); return}
            
            switch result {
            case .success(_):
                closure(true)
            case .failure(let error):
                failAnimation?("HATA: \(error.localizedDescription)")
                closure(false)
            }
        }
    }
    
    private func isUserNameUsed(userId: String, newUsername: String,_ closure: @escaping(Bool) -> Void) {
        let collectionString = FirebaseCollections.users.rawValue
        let collection = Network.shared.database.collection(collectionString)
        let query = collection.whereField("username", isEqualTo: newUsername).whereField("id", isNotEqualTo: userId)
        
        Network.shared.getOne(of: UserModel.self, with: query) {[weak self] (result: Result<UserModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(_):
                self.failAnimation?("Kullanıcı adınız başka kullanıcı tarafından kullanılıyor lütfen başka bir kullanıcı adı giriniz.")
                closure(true)
            case .failure(let error):
                print(error.localizedDescription)
                closure(false)
            }
        }
    }
    
    func deleteAccount(_ closure: @escaping(Bool) -> Void) {
        
        loadingAnimationStart?("Silme işleminiz Devam Ediyor Lütfen Bekleyiniz..")
        AuthManager.shared.deleteAccount { [weak self] status, error in
            guard let self else {return}
            
            guard status else {
                self.failAnimation?("HATA: \(error?.localizedDescription ?? "Bilinmeyen Bir Hata Oluştu")")
                closure(false); return
            }
            
            self.successAnimation?("Hesabınız Başarıyla Silindi")
            closure(true)
        }
    }
}
