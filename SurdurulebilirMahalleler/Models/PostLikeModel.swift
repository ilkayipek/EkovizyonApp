//
//  PostLikeModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 26.05.2024.
//

import Foundation

struct PostLikeModel: FirebaseIdentifiable {
    var id: String
    let userId: String
    let postId: String
    
    init(id: String = UUID().uuidString, userId: String, postId: String) {
        self.id = id
        self.userId = userId
        self.postId = postId
    }
    
}
