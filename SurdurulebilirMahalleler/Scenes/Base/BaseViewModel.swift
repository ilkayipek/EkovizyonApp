//
//  BaseViewModel.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import Foundation

class BaseViewModel {
    var loadingAnimationStart: ((String) -> Void)?
    var loadingAnimationStop: (() -> Void)?
    var successAnimation: ((String) -> Void)?
    var failAnimation: ((String) -> Void)?
    var alertMessage: ((String, String ,String) -> Void)?
    var gradientLoagingTabAnimation: CustomGradientLoadingAnimation?
}
