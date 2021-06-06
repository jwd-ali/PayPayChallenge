//
//  SupportedCurrenciesViewModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import Combine
protocol SupportedCurrenciesViewModelType {
    var itemSubject: CurrentValueSubject<[SupportedTableCellViewModel], Never> { get }
    var title: AnyPublisher<String?, Never> { get }
    var selectedCurrency: PassthroughSubject<Int, Never> { get }
}
class SupportedCurrenciesViewModel: SupportedCurrenciesViewModelType {
    var selectedCurrency = PassthroughSubject<Int, Never>()
    var title: AnyPublisher<String?, Never> { currencyTitleSubject.eraseToAnyPublisher() }
    var itemSubject: CurrentValueSubject<[SupportedTableCellViewModel], Never>
    
    
    private let currencyTitleSubject = CurrentValueSubject<String?, Never>("Select Currency")
    private var subscriptions = Set<AnyCancellable>()
    init(currencies: [CurrencyModel], selectCurrency: @escaping (CurrencyModel) -> Void) {
        let supportedItems = currencies.map { currency in
            SupportedTableCellViewModel(currency)
        }
        
        itemSubject = CurrentValueSubject(supportedItems)
        
        selectedCurrency
            .sink(receiveValue: { index in
                selectCurrency(currencies[index])
            })
            .store(in: &subscriptions)
    }
}
