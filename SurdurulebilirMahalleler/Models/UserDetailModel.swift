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
    var email: String?
    var phoneNumber: String?
    var pointRef: DocumentReference?
    var totalAttendedEvents: Int
    var totalLocationsVisited: Int
    var totalPost: Int
    var totalFollow: Int
    var totalFollower: Int
    var dateOfBirth: Date
    var country: String
    var fullName: String?
    var username: String?
    var profileImageUrl: String?
    var profileImageId: String
    let pointDetail: PointDetail?
    
    init(
        id: String,
        email: String? = "",
        phoneNumber: String? = "",
        pointRef: DocumentReference? = nil,
        totalAttendedEvents: Int = 0,
        totalLocationsVisited: Int = 0,
        totalPost: Int = 0,
        totalFollow: Int = 0,
        totalFollower: Int = 0,
        dateOfBirth: Date = Date(),
        country: String = "",
        fullName: String? = "",
        username: String,
        profileImageUrl: String? = "",
        profileImageId: String = UUID().uuidString,
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
        self.profileImageId = profileImageId
        self.pointDetail = pointDetail
        self.totalPost = totalPost
    }
}
