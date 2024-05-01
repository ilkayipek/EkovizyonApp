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
    var availablePoint: Int
    var userRef: DocumentReference?
    var userModel: UserModel?
    
    init(
        id: String = UUID().uuidString,
        totalScore: Int = 0,
        weeklyScore: Int = 0,
        monthlyScore: Int = 0,
        totalEventPoint: Int = 0,
        totalLocationPoint: Int = 0,
        availablePoint:Int = 0,
        userRef: DocumentReference? = nil,
        userModel: UserModel? = nil
    ) {
        self.id = id
        self.totalScore = totalScore
        self.weeklyScore = weeklyScore
        self.monthlyScore = monthlyScore
        self.totalEventPoint = totalEventPoint
        self.totalLocationPoint = totalLocationPoint
        self.availablePoint = availablePoint
        self.userRef = userRef
        self.userModel = userModel
    }
}
