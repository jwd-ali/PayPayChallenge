//
//  PayTableViewCell.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import UIKit
protocol ConfigurableCell {
    func configure(with viewModel: Any)
}
typealias PayUITableViewCell =  UITableViewCell & ReusableView & ConfigurableCell
