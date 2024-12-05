//
//  UserDetailModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 18.04.2024.
//

import Foundation
import FirebaseFirestore

struct UserDetailModel: FirebaseIdentifiable {
    var id: String
    let email: String?
    let phoneNumber: String?
    let pointRef: DocumentReference?
    var totalAttendedEvents: Int
    var totalLocationsVisited: Int
    var totalFollow: Int
    var totalFollower: Int
    let dateOfBirth: Date
    let country: String
    let fullName: String?
    let username: String?
    let profileImageUrl: String?
    let pointDetail: PointDetail?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case phoneNumber
        case pointRef
        case totalAttendedEvents
        case totalLocationsVisited
        case totalFollow
        case totalFollower
        case pointDetail
        case dateOfBirth = "dateOfBird"
        case country
        case fullName = "fullName"
        case username
        case profileImageUrl = "profileImageUrl"
    }
    
    init(
        id: String,
        email: String? = "",
        phoneNumber: String? = "",
        pointRef: DocumentReference? = nil,
        totalAttendedEvents: Int = 0,
        totalLocationsVisited: Int = 0,
        totalFollow: Int = 0,
        totalFollower: Int = 0,
        dateOfBirth: Date = Date(),
        country: String = "",
        fullName: String? = "",
        username: String,
        profileImageUrl: String? = "",
        pointDetail: PointDetail? = nil
    ) {
        self.id = id
        self.email = email
        self.phoneNumber = phoneNumber
        self.pointRef = pointRef
        self.totalAttendedEvents = totalAttendedEvents
        self.totalLocationsVisited = totalLocationsVisited
        self.totalFollow = totalFollow
        self.totalFollower = totalFollower
        self.dateOfBirth = dateOfBirth
        self.country = country
        self.fullName = fullName
        self.username = username
        self.profileImageUrl = profileImageUrl
        self.pointDetail = pointDetail
    }
}
