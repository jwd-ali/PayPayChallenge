//
//  ReusableView.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
import UIKit

protocol ReusableView: class {}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
