//
//  SupportedCurrenciesViewController.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import Foundation
import UIKit
import Combine

class SupportedCurrenciesViewController: UIViewController {
    
    // MARK: - Views
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Properties
    private var viewModel: SupportedCurrenciesViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: SupportedCurrenciesViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupObservers()
    }
    
}

private extension SupportedCurrenciesViewController {
    func setupViews(){
        view.backgroundColor = .white
        tableView.register(SupportedTableViewCell.self, forCellReuseIdentifier: SupportedTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
    }
    func setupConstraints(){
        tableView
            .alignEdgeWithSuperviewSafeArea(.top)
            .alignEdgeWithSuperviewSafeArea(.bottom)
            .alignEdgesWithSuperview([.left, .right], constant: 20)
    }
    func setupObservers(){
        viewModel.title
            .assign(to: \.title, on: navigationItem)
            .store(in: &subscriptions)
    }
}

extension SupportedCurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: SupportedTableViewCell.reuseIdentifier, for: indexPath) as? SupportedTableViewCell
        else {
            return UITableViewCell()
            
        }
        cell.configure(with: viewModel.itemSubject.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.itemSubject.value.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print( viewModel.itemSubject.value[indexPath.row].currencyName)
        viewModel.selectedCurrency.send(indexPath.row)
    }
}
