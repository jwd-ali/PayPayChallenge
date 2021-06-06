//
//  CurrencyMainViewController.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import UIKit
import Combine

class CurrencyMainViewController: UIViewController {
    
    // MARK: - Views
    private lazy var activityIndicator = ActivityView(style: .large)
    
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
    
    private var currencyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let currencyTextField: PaddedField = {
        let textField = PaddedField()
        textField.textAlignment = .right
        textField.layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.backgroundColor = .white
        textField.keyboardType = .decimalPad
        textField.placeholder = "0.00"
        return textField
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Properties
    private var viewModel: CurrencyMainViewModelType
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: CurrencyMainViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViews()
        setupConstraints()
        setupObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    @objc func refreshCurrencies() {
        currencyTextField.text = nil
        viewModel.tapRefresh.send()
    }
    
    @objc func tapCurrency() {
        viewModel.tapCurrency.send()
    }
    
    @objc func currencyFieldChanged() {
        viewModel.changeAmount.send(Double(currencyTextField.text ?? "") ?? 0)
    }
}

private extension CurrencyMainViewController {
    func setupNavigationBar() {
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshCurrencies))
        navigationItem.leftBarButtonItem = refreshItem
    }
    
    func setupViews() {
        view.backgroundColor = .white
        currencyButton.addTarget(self, action: #selector(tapCurrency), for: .touchUpInside)
        currencyTextField.addTarget(self, action: #selector(currencyFieldChanged), for: .editingChanged)
        tableView.register(ExchangeTableViewCell.self, forCellReuseIdentifier: ExchangeTableViewCell.reuseIdentifier)
        
        mainStack.addArrangedSubview(currencyButton)
        mainStack.addArrangedSubview(currencyTextField)
        
        view.addSubview(mainStack)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
       
        mainStack
            .alignEdgeWithSuperviewSafeArea(.top, constant: 20)
            .alignEdgesWithSuperview([.left, .right], constant: 20)
        
        currencyTextField
            .height(constant: 50)
        
        tableView
            .toBottomOf(mainStack, constant: 20)
            .alignEdgesWithSuperview([.left, .right], constant: 20)
            .alignEdgeWithSuperviewSafeArea(.bottom)
    }
    
    func setupObservers() {
        viewModel.tapRefresh.send()
        
        viewModel.title
            .assign(to: \.title, on: navigationItem)
            .store(in: &subscriptions)
        
        viewModel.currencyTitle
            .sink(receiveValue: { [weak self] title in
                self?.currencyButton.setTitle(title, for: .normal)
            })
            .store(in: &subscriptions)
        
        viewModel.isLoading
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] isLoading in
                guard let self = self else {return}
                isLoading ? self.view.addSubview(self.activityIndicator) : self.activityIndicator.removeFromSuperview()
            })
            .store(in: &subscriptions)
        
        viewModel.cellViewModels
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .store(in: &subscriptions)
    }
    
}
extension CurrencyMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeTableViewCell.reuseIdentifier, for: indexPath) as? ExchangeTableViewCell
        else {
            return UITableViewCell()
            
        }
        cell.configure(with: viewModel.cellViewModels.value[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewModels.value.count
    }
}
