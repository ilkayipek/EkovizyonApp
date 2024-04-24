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
    let contentImageUrl: String?
    let timestamp: Date
    var totalLike: Int
    var totalComment: Int
    
    // FirebaseIdentifiable gereksinimi için init metodu
    init(id: String,
         userReference: DocumentReference? = nil,
         contentText: String,
         contentImageUrl: String? = nil,
         timestamp: Date = Date(),
         totalLike: Int = 0,
         totalComment: Int = 0) {
        self.id = id
        self.userReference = userReference
        self.contentText = contentText
        self.contentImageUrl = contentImageUrl
        self.timestamp = timestamp
        self.totalLike = totalLike
        self.totalComment = totalComment
    }
}
