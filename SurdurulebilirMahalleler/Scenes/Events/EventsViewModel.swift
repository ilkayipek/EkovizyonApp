//
//  EventsViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 28.04.2024.
//
import Foundation

class EventsViewModel: BaseViewModel {
    func getEvenents(_ closure: @escaping([EventModel]?) -> Void) {
        
        gradientLoagingTabAnimation?.startAnimations()
        let collection = Network.shared.database.collection(FirebaseCollections.events.rawValue)
        let query = collection.order(by: "date", descending: true)
        
        Network.shared.getMany(of: EventModel.self, with: query) { [weak self] (result: Result<[EventModel], any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let success):
                guard !success.isEmpty else { closure(nil); return}
                closure(success)
                
            case .failure(let error):
                closure(nil)
                self.failAnimation?("HATA: \(error.localizedDescription)")
            }
            self.gradientLoagingTabAnimation?.stopAnimations()
        }
    }
    
    func checkEventVerificationCode(_ verificationCode: String, _ closure: @escaping(Bool) -> Void) {
        let collection = Network.shared.database.collection(FirebaseCollections.events.rawValue)
        let query = collection.whereField("verificationCode", isEqualTo: verificationCode)
        
        loadingAnimationStart?("Doğrulanıyor..")
        Network.shared.getOne(of: EventModel.self, with: query) { [weak self] (result: Result<EventModel, any Error>) in
            
            guard let self else {return}
            
            switch result {
            case .success(let data):
                self.updateUserPointDocument(data.point, closure)
            case .failure(let error):
                self.failAnimation?("Doğrulama başarısız: \(error.localizedDescription)")
                closure(false)
            }
        }
        
    }
    
    private func updateUserPointDocument(_ point: Int, _ closure: @escaping(Bool) ->Void) {
        let pointDetail: PointDetail? = UserInfo.shared.retrieve(key: .pointDetail)
        guard let pointDetail else {return}
        var newDetailpoint = pointDetail
        
        newDetailpoint.totalScore  = pointDetail.totalScore + point
        newDetailpoint.availablePoint = pointDetail.availablePoint + point
        
        Network.shared.put(newDetailpoint, to: .pointDetails) { [weak self] (result: Result<PointDetail, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                self.updateTotalAttendedEvents(data, closure)
            case .failure(let error):
                self.failAnimation?("Puan Hesabınızda tanımlanırken bir hata oluştu:\(error.localizedDescription)")
                closure(false)
            }
        }
    }
    
    private func updateTotalAttendedEvents(_ pointDetail: PointDetail,_ closure: @escaping(Bool) -> Void) {
        
        guard let userId = AuthManager.shared.auth.currentUser?.uid else {closure(false); return}
        let userDetailModel: UserDetailModel? = UserInfo.shared.retrieve(key: .userDetail)
        guard var userDetailModel else {closure(false); return}
        
        userDetailModel.totalAttendedEvents += 1
        Network.shared.put(userDetailModel, to: .userDetails) {[weak self] (result: Result<UserDetailModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let userDetail):
                UserInfo.shared.store(key: .pointDetail, value: pointDetail)
                UserInfo.shared.store(key: .userDetail, value: userDetail)
                self.successAnimation?("Kayıt Başarılı\nKullanılabili Puan: \(pointDetail.availablePoint)\nToplam Ziyaret:\(userDetail.totalAttendedEvents)")
                closure(true)
            case .failure(let error):
                self.failAnimation?("toplam ziyaret güncellemesi sırasında bir hata oluşru: \(error.localizedDescription)")
                closure(false)
            }
        }
    }
}
