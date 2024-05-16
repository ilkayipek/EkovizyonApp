//
//  UserModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 11.04.2024.
//

import Foundation
import FirebaseFirestore

struct UserModel: FirebaseIdentifiable {
    var id: String
    let userDetailRef: DocumentReference?
    let pointRef: DocumentReference?
    var name: String?
    var username: String?
    var profileUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case userDetailRef = "userDetailRef"
        case pointRef = "pointDetailsRef"
        case name = "fullName"
        case profileUrl = "profileImageUrl"
    }
    
    init(
        id: String,
        userDetailRef: DocumentReference? = nil,
            pointRef: DocumentReference? = nil,
            name: String = "",
        username: String,
            profileUrl: String = "",
        pointModel: PointDetail? = nil
        ) {
            self.id = id
            self.userDetailRef = userDetailRef
            self.pointRef = pointRef
            self.name = name
            self.username = username
            self.profileUrl = profileUrl
        }
}
