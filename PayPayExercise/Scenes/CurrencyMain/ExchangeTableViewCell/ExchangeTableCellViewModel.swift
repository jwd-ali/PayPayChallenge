//
//  ExchangeTableCellViewModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import Combine
protocol ExchangeTableCellViewModelType {
    var amountToExchange: PassthroughSubject<Double, Never> { get set }
    var currencyName: AnyPublisher<String?, Never> { get }
    var currencyValue: AnyPublisher<String?, Never> { get }
}

class ExchangeTableCellViewModel: ExchangeTableCellViewModelType {
    var amountToExchange = PassthroughSubject<Double, Never>()
    var currencyName: AnyPublisher<String?, Never> { currencyTitleSubject.eraseToAnyPublisher() }
    var currencyValue: AnyPublisher<String?, Never> { currencyValueSubject.eraseToAnyPublisher() }
    
    //MARK:- Subjects
    private let currencyTitleSubject: CurrentValueSubject<String?, Never>
    private let currencyValueSubject = CurrentValueSubject<String?, Never>(nil)
    private var subscribers = Set<AnyCancellable>()
    
    init(currency: CurrencyModel) {
        let currencyTitle = currency.name + " - " + currency.code
        currencyTitleSubject = CurrentValueSubject(currencyTitle)
        
        amountToExchange
            .sink(receiveValue: { [weak self] amount in
                self?.currencyValueSubject.send(String(format:"%.2f", currency.rate * amount))
            }).store(in: &subscribers)
    }
}
