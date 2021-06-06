//
//  CurrencyMainViewModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import UIKit
import Combine

protocol CurrencyMainViewModelType {
    var tapRefresh: PassthroughSubject<Void, NetworkRequestError> { get  }
    var changeAmount: PassthroughSubject<Double, Never> { get  }
    var isLoading: CurrentValueSubject<Bool, Never> { get }
    var title: AnyPublisher<String?, Never> { get }
    var currencyTitle: AnyPublisher<String?, Never> { get }
    var tapCurrency: PassthroughSubject<Void, Never> { get }
    var cellViewModels: CurrentValueSubject<[ExchangeTableCellViewModel], Never> { get }
    var openSupportedList: PassthroughSubject<Void, Never> { get }
    var selectCurrencySubject: PassthroughSubject<CurrencyModel, Never> { get }
}

class CurrencyMainViewModel: CurrencyMainViewModelType {
    
    var tapRefresh = PassthroughSubject<Void, NetworkRequestError>()
    var changeAmount = PassthroughSubject<Double, Never>()
    var tapCurrency = PassthroughSubject<Void, Never>()
    var isLoading = CurrentValueSubject<Bool, Never>(false)
    var title: AnyPublisher<String?, Never> { titleSubject.eraseToAnyPublisher() }
    var currencyTitle: AnyPublisher<String?, Never> { currencyTitleSubject.eraseToAnyPublisher() }
    var cellViewModels = CurrentValueSubject<[ExchangeTableCellViewModel], Never>([])
    var openSupportedList = PassthroughSubject<Void, Never>()
    var selectCurrencySubject = PassthroughSubject<CurrencyModel, Never>()
    
    private let titleSubject = CurrentValueSubject<String?, Never>("Currency Exchange")
    private let currencyTitleSubject = CurrentValueSubject<String?, Never>("Select Currency")
    
    
    //Diffable datasource
    private let currenciesSubject = PassthroughSubject<[CurrencyModel], NetworkRequestError>()
    private var selectedCurrency: CurrencyModel?
    
    private let repository: RepositoryType
    private var subscriptions = Set<AnyCancellable>()
    
    init(repository: RepositoryType, selectedCurrency: CurrencyModel?) {
        self.repository = repository
        self.selectedCurrency = selectedCurrency
       
        configureRefresh()
        
        if let selected = selectedCurrency {
        selectCurrencySubject.send(selected)
        }
    }
    
    private func configureRefresh() {
        tapRefresh
            .flatMap { [unowned self] _ in
                self.getCurrencies()
            }.map { [unowned self] currencies in
                self.getCellViewModels(from: currencies)
            }
            .sink(receiveCompletion: { result in
                self.isLoading.send(false)

                switch result {
                case .failure(_):
                    print("track/assert/handle error")
                default:
                    break
                }
            }, receiveValue: { [unowned self] items in
                self.cellViewModels.send(items)
                self.isLoading.send(false)
            })
            .store(in: &subscriptions)
           
        changeAmount
            .combineLatest(selectCurrencySubject)
            .sink(receiveValue: { [unowned self] amount, currency in
                self.updateAllRates(amount)
            })
            .store(in: &subscriptions)
        
        tapCurrency
            .sink(receiveValue: { [unowned self] _ in
                self.openSupportedList.send()
            })
            .store(in: &subscriptions)
        
        selectCurrencySubject
            .sink(receiveValue: { [unowned self] currency in
                self.selectedCurrency = currency
                self.currencyTitleSubject.send(currency.name)
            })
            .store(in: &subscriptions)
    }
}

private extension CurrencyMainViewModel {
     func updateAllRates(_ amount: Double) {
        guard let selectedCurrency = selectedCurrency else { return }
        let amountUSD = amount / selectedCurrency.rate
        
        for item in cellViewModels.value {
            item.amountToExchange.send(amountUSD)
        }
    }
    
    private func getCellViewModels(from currencies: [CurrencyModel]) -> [ExchangeTableCellViewModel] {
         currencies.map { ExchangeTableCellViewModel(currency: $0) }
    }
    
    private func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        isLoading.send(true)
        cellViewModels.send([])
        
        return repository.getCurrencies()
    }
}
