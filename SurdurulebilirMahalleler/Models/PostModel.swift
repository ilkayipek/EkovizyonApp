//
//  PostModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 23.04.2024.
//

import FirebaseFirestore

struct PostModel: FirebaseIdentifiable {
    var id: String
    let userReference: DocumentReference?
    let contentText: String
    var contentImageUrl: String?
    let timestamp: Date
    var totalLike: Int
    var totalComment: Int
    var userModel: UserModel?
    
    init(id: String = UUID().uuidString,
         userReference: DocumentReference,
         contentText: String ,
         contentImageUrl: String = "",
         timestamp: Date = Date(),
         totalLike: Int = 0,
         totalComment: Int = 0,
         userModel: UserModel? = nil) {
        self.id = id
        self.userReference = userReference
        self.contentText = contentText
        self.contentImageUrl = contentImageUrl
        self.timestamp = timestamp
        self.totalLike = totalLike
        self.totalComment = totalComment
        self.userModel = userModel
    }
}
