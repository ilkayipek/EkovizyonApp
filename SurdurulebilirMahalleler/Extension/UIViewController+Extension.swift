//
//  UIViewController+Extension.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 20.04.2024.
//

import Foundation
import UIKit.UIViewController

extension UIViewController {
    static func loadFromNib() -> Self{
        func instantiateFromNib<T: UIViewController>() ->T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib()
    }
}
