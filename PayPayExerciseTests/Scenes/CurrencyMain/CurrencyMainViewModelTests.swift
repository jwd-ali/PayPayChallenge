//
//  CurrencyMainViewModelTests.swift
//  PayPayExerciseTests
//
//  Created by Jawad Ali on 05/05/2021.
//

import Combine
import XCTest
@testable import PayPayExercise
class CurrencyMainViewModelTests: XCTestCase {
    var sut: CurrencyMainViewModel!
    var repository: MockCurrencyRepository!
    var defaults: MockCurrencyDefaults!
    var service: MockCurrencyService!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
       try super.setUpWithError()
        self.repository = MockCurrencyRepository()
        self.defaults = MockCurrencyDefaults()
        self.service = MockCurrencyService()
        self.sut = CurrencyMainViewModel(repository: repository, selectedCurrency: defaults.selectedCurrency)
    }
    
    override func tearDownWithError() throws {
        repository = nil
        defaults = nil
        service = nil
        sut = nil
    }
    
    func test_view_model_creation_success() {
        sut.tapRefresh.send(())
        XCTAssertFalse(sut.cellViewModels.value.isEmpty)
    }
    
    func test_selected_currency_load() {
        sut.selectCurrencySubject.sink { (model) in
            XCTAssertNotNil(model)
        }.store(in: &subscriptions)
    }
    
}
