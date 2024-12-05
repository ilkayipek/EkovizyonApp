//
//  EventParticipantModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 1.05.2024.
//

import Foundation

struct EventParticipantModel: FirebaseIdentifiable {
    var id: String
    var userId: String
    var eventId: String
    
    init(id: String = UUID().uuidString,
         userId: String,
         eventId: String) {
        self.id = id
        self.userId = userId
        self.eventId = eventId
    }
}
