//
//  UIImage+Assets.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 22.05.2024.
//

import UIKit.UIImage

extension UIImage {
    
    static func image(from assets: NamedImageAssets) -> UIImage? {
        return UIImage(named: assets.rawValue)
    }
}
