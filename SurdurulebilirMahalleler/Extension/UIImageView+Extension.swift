//
//  UIImageView+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 24.04.2024.
//

import SDWebImage

extension UIImageView {
    func loadImage(url: URL, placeHolderImage: UIImage?,_ completion: SDExternalCompletionBlock?) {
        self.sd_setImage(with: url, placeholderImage: placeHolderImage, options: [.refreshCached, .continueInBackground], completed: completion)
    }
}
