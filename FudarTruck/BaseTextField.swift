//
//  BaseTextField.swift
//  FudarTruck
//
//  Created by Michael Sevy on 10/21/17.
//  Copyright © 2017 Michael Sevy. All rights reserved.
//

import UIKit
import UITextField_Shake
import JVFloatLabeledTextField

@IBDesignable class LYTextField: JVFloatLabeledTextField {

    // MARK: - Private Instance Attributes
    fileprivate var _amountOfShakes: Int32 = 10
    fileprivate var _amountOfPointsWide: CGFloat = 10.0
    fileprivate var _xCoordinateForAdjusting: CGFloat = 10.0
    fileprivate var _yCoordinateForAdjusting: CGFloat = 10.0


    // MARK: - IBInspectable
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderType: UITextBorderStyle = .none {
        didSet {
            borderStyle = borderType
        }
    }

    @IBInspectable var fontColor: UIColor = .darkGray {
        didSet {
            textColor = fontColor
        }
    }

    @IBInspectable var amountOfShakes: Int32 = 10 {
        didSet {
            _amountOfShakes = amountOfShakes
        }
    }

    @IBInspectable var amountOfPointsWide: CGFloat = 10.0 {
        didSet {
            _amountOfPointsWide = amountOfPointsWide
        }
    }

    @IBInspectable var xCoordinateForAdjusting: CGFloat = 10.0 {
        didSet {
            _xCoordinateForAdjusting = xCoordinateForAdjusting
        }
    }

    @IBInspectable var yCoordinateForAdjusting: CGFloat = 10.0 {
        didSet {
            _yCoordinateForAdjusting = yCoordinateForAdjusting
        }
    }
}


// MARK: - Public Instance Methods
extension LYTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: _xCoordinateForAdjusting, dy: _yCoordinateForAdjusting)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }

    /// Performs a shake animation on the current instance.
    func performShakeAnimation() {
        shake(_amountOfShakes, withDelta: _amountOfPointsWide)
    }
}

