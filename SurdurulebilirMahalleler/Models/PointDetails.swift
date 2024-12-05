//
//  PointDetails.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 18.04.2024.
//

import Foundation
import FirebaseFirestore

struct PointDetail: FirebaseIdentifiable {
    var id: String
    var totalScore: Int
    var weeklyScore: Int
    var monthlyScore: Int
    var totalEventPoint: Int
    var totalLocationPoint: Int
    var userRef: DocumentReference?
    var userModel: UserModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case totalScore
        case weeklyScore
        case monthlyScore
        case totalEventPoint
        case totalLocationPoint
        case userRef
        case userModel
    }
    
    init(
        id: String = UUID().uuidString,
        totalScore: Int = 0,
        weeklyScore: Int = 0,
        monthlyScore: Int = 0,
        totalEventPoint: Int = 0,
        totalLocationPoint: Int = 0,
        userRef: DocumentReference? = nil,
        userModel: UserModel? = nil
    ) {
        self.id = id
        self.totalScore = totalScore
        self.weeklyScore = weeklyScore
        self.monthlyScore = monthlyScore
        self.totalEventPoint = totalEventPoint
        self.totalLocationPoint = totalLocationPoint
        self.userRef = userRef
        self.userModel = userModel
    }
}
