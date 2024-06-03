//
//  HomeFeedFelegate.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 26.05.2024.
//

import UIKit.UIImage


protocol HomeFeedDelegate {
    
    func likePost(post: PostModel,_ closure: @escaping(_ likeId: String?) -> Void)
    func unlikePost(post: PostModel,_ closure: @escaping(Bool) -> Void)
    func userSelected(_ userId: String)
    func commentsSelected(_ postId: String)
    func updateCell(_ cell: FeedTableViewCell)
    func imageSelected(_ image: UIImage?)
}
