//
//  SupportedTableViewCell.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import Combine
import UIKit
class SupportedTableViewCell: PayUITableViewCell {
    
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
    private var viewModel: SupportedTableCellViewModelType!
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Configuration
    func configure(with viewModel: Any) {
        guard let `viewModel` = viewModel as? SupportedTableCellViewModelType else { return }
        self.viewModel = viewModel
        bindViews()
    }
}
private extension SupportedTableViewCell {
    func bindViews() {
        
        viewModel.currencyName
            .sink(receiveValue: { [weak self] name in
                self?.textLabel?.text = name
            })
            .store(in: &subscriptions)
    }
}
