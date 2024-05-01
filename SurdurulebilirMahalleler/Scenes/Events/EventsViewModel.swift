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
        var pointDetail: PointDetail? = UserInfo.shared.retrieve(key: .pointDetail)
        guard let pointDetail else {return}
        var newDetailpoint = pointDetail
        
        newDetailpoint.totalScore  = pointDetail.totalScore + point
        newDetailpoint.availablePoint = pointDetail.availablePoint + point
        
        Network.shared.put(newDetailpoint, to: .pointDetails) { [weak self] (result: Result<PointDetail, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(let data):
                self.successAnimation?("Puan hesabınıza yüklendi\nGüncel puan: \(data.totalEventPoint).\nKullanılabilir Puan:\(data.availablePoint)")
                UserInfo.shared.store(key: .pointDetail, value: data)
                closure(true)
            case .failure(let error):
                self.failAnimation?("Puan Hesabınızda tanımlanırken bir hata oluştu:\(error.localizedDescription)")
                closure(false)
            }
        }
    }
}
