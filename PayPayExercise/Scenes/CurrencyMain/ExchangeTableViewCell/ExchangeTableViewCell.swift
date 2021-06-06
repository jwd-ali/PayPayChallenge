//
//  ExchangeTableViewCell.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import UIKit
import Combine
class ExchangeTableViewCell: PayUITableViewCell {
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        selectionStyle = .none

    }
    
    // MARK: - Properties
    private var viewModel: ExchangeTableCellViewModelType!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Configuration
     func configure(with viewModel: Any) {
        guard let `viewModel` = viewModel as? ExchangeTableCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
}
private extension ExchangeTableViewCell {
    func bindViews() {
        viewModel.currencyValue
            .sink(receiveValue: { [weak self] amount in
                self?.detailTextLabel?.text = amount
            })
            .store(in: &subscriptions)
        
        viewModel.currencyName
            .sink(receiveValue: { [weak self] name in
                self?.textLabel?.text = name
            })
            .store(in: &subscriptions)
        
//        guard let detail = detailTextLabel, let titleLabel = textLabel else {
//            return
//        }
//        self.subscriptions = [
//            viewModel.currencyValue.assign(to: \.text, on: detail),
//            viewModel.currencyName.assign(to: \.text, on: titleLabel),
//        ]
    }
}
