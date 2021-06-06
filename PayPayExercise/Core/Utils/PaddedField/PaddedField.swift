//
//  PaddedField.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import UIKit
class PaddedField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
