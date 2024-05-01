//
//  EventsModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 30.04.2024.
//

import Foundation

struct EventModel: FirebaseIdentifiable {
    var id: String
    let title: String
    var bannerImageUrl: String?
    let ownerName: String
    let adress: String
    let date: Date
    var verificationCode: String
    let infoText: String
    var point: Int
    var totalParticipant: Int
    
    init(id: String = UUID().uuidString,
         title: String = "",
         bannerImageUrl: String? = "",
         ownerName: String = "",
         adress: String = "",
         date: Date,
         verificationCode: String = "",
         infoText: String = "",
         point: Int = 0,
         totalParticipant: Int = 0) {
        self.id = id
        self.title = title
        self.bannerImageUrl = bannerImageUrl
        self.ownerName = ownerName
        self.adress = adress
        self.date = date
        self.verificationCode = verificationCode
        self.infoText = infoText
        self.point = point
        self.totalParticipant = totalParticipant
    }
}
