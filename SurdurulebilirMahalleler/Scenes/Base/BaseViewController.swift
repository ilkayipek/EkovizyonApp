//
//  BaseViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 15.04.2024.
//

import UIKit
import ProgressHUD

class BaseViewController<V: BaseViewModel>: UIViewController {
    
    var gradientLoagingTabAnimation: CustomGradientLoadingAnimation?
    
    var viewModel: V? {
        didSet {
            setViewModel()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gradientLoagingTabAnimation?.stopAnimations()
    }
    
    func setViewModel() {
        setPageLoadingAnimation()
        
        viewModel?.loadingAnimationStart = { [weak self] text in
            guard let self else {return}
            self.loadingAnimationStart(text: text)
        }
        
        viewModel?.loadingAnimationStop = { [weak self] in
            guard let self else {return}
            self.loadingAnimationStop()
        }
        
        viewModel?.successAnimation = { [weak self] text in
            guard let self else {return}
            self.successAnimation(text: text)
        }
        
        viewModel?.failAnimation = { [weak self] text in
            guard let self else {return}
            self.failAnimation(text: text)
        }
    }
    
    func loadingAnimationStart(text: String) {
        ProgressHUD.animate(text, .circleStrokeSpin)
    }
    
    func loadingAnimationStop() {
        ProgressHUD.dismiss()
    }
    
    func successAnimation(text: String) {
        ProgressHUD.succeed(text,delay: 1.5)
    }
    
    func failAnimation(text: String) {
        ProgressHUD.failed(text)
    }
    
    func setPageLoadingAnimation() {
        self.gradientLoagingTabAnimation = CustomGradientLoadingAnimation(x: 0, y: 0, width: view.frame.width*0.8, height: 5, color: UIColor(named: "DetailButtonBackgroundColor") ?? .black)
        viewModel?.gradientLoagingTabAnimation = self.gradientLoagingTabAnimation
        self.navigationController?.navigationBar.addSubview(gradientLoagingTabAnimation!)
    }
}
