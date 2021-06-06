//
//  CurrencyRepository.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
import Combine
protocol CurrencyRepositoryType {
    func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError>
}

protocol RepositoryType: CurrencyRepositoryType  {
    func saveSelectedCurrency(_ currency: CurrencyModel)
    func saveCurrencies(_ currencies: [CurrencyModel])
}

protocol LocalRepositoryType: RepositoryType {
    func timeStamp() -> Date
}

class RemoteRepository: CurrencyRepositoryType {
    private let service: CurrencyServiceType
    
    init(service: CurrencyServiceType) {
        self.service = service
    }
    
    func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        Publishers.CombineLatest(getRateCurrency(), getSupportedCurrency())
            .map { rate, supported in
                let currencies = supported.currencies.map { supportedCurrency in
                    CurrencyModel(name: supportedCurrency.value,
                                  code: supportedCurrency.key,
                                  rate: rate.quotes[rate.source+supportedCurrency.key] ?? 0)
                }.sorted()
                return currencies
            }
            .eraseToAnyPublisher()
    }
    
    private func getSupportedCurrency() -> AnyPublisher<SupportedModel, NetworkRequestError> {
         service.getCurrenciesList()
    }
    
    private  func getRateCurrency() -> AnyPublisher<RateModel, NetworkRequestError> {
        service.getRatesList()
    }
}

class LocalRepository: LocalRepositoryType {
    
    private var storage: CurrencyDefaultsType
    init(storage: CurrencyDefaultsType) {
        self.storage = storage
    }
    
    func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        Result.Publisher(storage.currencies).eraseToAnyPublisher()
    }
    
    func saveSelectedCurrency(_ currency: CurrencyModel) {
        storage.selectedCurrency = currency
    }
    
    func saveCurrencies(_ currencies: [CurrencyModel]) {
        storage.currencies = currencies
        storage.timestamp = Date()
    }
    
    func timeStamp() -> Date {
        storage.timestamp
    }
}

class RemoteCurrencyLoaderWithLocalLoader: RepositoryType {
    
    private let local: LocalRepositoryType
    private let remote: CurrencyRepositoryType
    
    init(remoteRepository: CurrencyRepositoryType, localRepository: LocalRepositoryType) {
        self.local = localRepository
        self.remote = remoteRepository
    }
    
    func saveSelectedCurrency(_ currency: CurrencyModel) {
        local.saveSelectedCurrency(currency)
    }
    
    func saveCurrencies(_ currencies: [CurrencyModel]) {
        local.saveCurrencies(currencies)
    }
    
    func getCurrencies() -> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        shouldLoadRemoteCurrencies ? getAndSaveCurrencies() : local.getCurrencies()
    }
    
    private func getAndSaveCurrencies()-> AnyPublisher<[CurrencyModel], NetworkRequestError> {
        
        remote.getCurrencies().handleEvents(receiveOutput: { [weak self] currencies in
            self?.local.saveCurrencies(currencies)
        }).eraseToAnyPublisher()
    }
    
    private var shouldLoadRemoteCurrencies: Bool {
        Calendar.current.dateComponents([.minute], from: local.timeStamp(), to: Date()).minute ?? 0 >= 30
    }
    
}
