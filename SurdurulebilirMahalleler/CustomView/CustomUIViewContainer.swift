//
//  CustomUIViewContainer.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 28.04.2024.
//

import UIKit.UIView

@IBDesignable
class CustomUIViewContainer: UIView {
    @IBInspectable var cornerRadiusValue: CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 1.0 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable var borderColor: UIColor = .black {
        didSet {
            setNeedsLayout()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpView()
    }

    private func setUpView() {
        layer.cornerRadius = cornerRadiusValue
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        clipsToBounds = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = cornerRadiusValue
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }
}

