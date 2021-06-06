//
//  SupportedTableCellViewModel.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 04/05/2021.
//

import Combine
protocol SupportedTableCellViewModelType {
    var currencyName: AnyPublisher<String?, Never> { get }
}

class SupportedTableCellViewModel: SupportedTableCellViewModelType {
    
    var currencyName: AnyPublisher<String?, Never> { currencyTitleSubject.eraseToAnyPublisher() }
    
    //MARK:- Subjects
    private let currencyTitleSubject: CurrentValueSubject<String?, Never>
    
    init(_ currency: CurrencyModel) {
        currencyTitleSubject = CurrentValueSubject(currency.name + " - " + currency.code)
    }
}
