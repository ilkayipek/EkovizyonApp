//
//  CustomGradientLoadingAnimation.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 16.04.2024.
//
import UIKit

class CustomGradientLoadingAnimation: UIView {
    private var internalX: Double
    private var internalY: Double
    private var internalWidth: Double
    private var internalHeight: Double
    
    private let gradientLayer = CAGradientLayer()
    private var animationTimer: Timer?
    private var gradientColor: UIColor!
    
    //initializer
    init(x: Double, y: Double, width: Double, height: Double, color: UIColor) {
        internalX = x
        internalY = y
        internalWidth = width
        internalHeight = height
        super.init(frame: CGRect(x: x, y: y, width: width, height: height))
        setupGradientLayer(color: color)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Setter fonksiyonları ile değerleri güncelle
    func updateFrame(x: Double, y: Double, width: Double, height: Double) {
        internalX = x
        internalY = y
        internalWidth = width
        internalHeight = height
        self.frame = CGRect(x: x, y: y, width: width, height: height)
        gradientLayer.frame = bounds
    }
    
    func getX() -> Double {
        return internalX
    }
    
    func getY() -> Double {
        return internalY
    }
    
    func getWidth() -> Double {
        return internalWidth
    }
    
    func getHeight() -> Double {
        return internalHeight
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    // using method customize Gradient layer
    private func setupGradientLayer(color: UIColor) {
        gradientLayer.isHidden = true
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.clear.cgColor, color.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: -1, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 2, y: 0.5)
        self.layer.addSublayer(gradientLayer)
    }
}

extension CustomGradientLoadingAnimation {
    private func startAnimation() {
        // Animation creat
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = -self.frame.width
        animation.toValue = 2 * self.frame.width
        animation.duration = 0.6
        
        // add animation of gradient layer
        gradientLayer.add(animation, forKey: "shimmerAnimation")
    }
    
    func startAnimations() {
        // Start animations sequentially over a period of time
        gradientLayer.isHidden = false
        startAnimation()
        
        if (animationTimer == nil) {
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                self.startAnimation()
            }
        }
    }
    
    func stopAnimations() {
        animationTimer?.invalidate()
        animationTimer = nil
        
        // stop all animations
        gradientLayer.removeAllAnimations()
        gradientLayer.isHidden = true
    }
    
}

