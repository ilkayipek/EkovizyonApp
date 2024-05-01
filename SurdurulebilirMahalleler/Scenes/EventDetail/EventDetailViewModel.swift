//
//  EventDetailViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import Foundation

class EventDetailViewModel: BaseViewModel {
    func joinEvent(_ eventId: String, _ closure: @escaping(Bool) -> Void) {
        
        guard let userId = AuthManager.shared.auth.currentUser?.uid else {return}
        let model = EventParticipantModel(userId: userId, eventId: eventId)
        
        Network.shared.post(model, to: .eventParticipants) {[weak self] (result: Result<EventParticipantModel, any Error>) in
            guard let self else {return}
            
            switch result {
            case .success(_):
                self.successAnimation?("Etkinliğe Kayıt Başarılı")
                closure(true)
            case .failure(let error):
                self.failAnimation?("Etkinliğe Kayıt Başarısız: \(error.localizedDescription)")
                closure(false)
            }
        }
    }
    
    func didYouAttendEvent(_ eventId: String, _ closure: @escaping(Bool) -> Void) {
        guard let userId = AuthManager.shared.auth.currentUser?.uid else {return}
        
        let collentionString = FirebaseCollections.eventParticipants.rawValue
        let collection = Network.shared.database.collection(collentionString)
        let query = collection.whereField("eventId", isEqualTo: eventId).whereField("userId", isEqualTo: userId)
        
        Network.shared.getOne(of: EventParticipantModel.self, with: query) {(result: Result<EventParticipantModel, any Error>) in
            
            switch result {
            case .success(_):
                print("Etkinliğe Kayıtlı.")
                closure(true)
            case .failure(let error):
                print("Etkinliğe Kayıtlı Değil. \(error.localizedDescription)")
                closure(false)
            }
        }
    }
}
