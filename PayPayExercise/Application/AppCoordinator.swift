//
//  AppCoordinator.swift
//  PayPayExercise
//
//  Created by Jawad Ali on 05/05/2021.
//

import Foundation
import UIKit
import Combine


class AppCoordinator: Coordinator<Void> {
    
    private let window: UIWindow
    private var root: UINavigationController!
    private lazy var currencyDefaults: CurrencyDefaultsType = CurrencyDefaults()
    private lazy var repository: RepositoryType = RemoteCurrencyLoaderWithLocalLoader(remoteRepository: RemoteRepository(service: CurrencyService()), localRepository: LocalRepository(storage: currencyDefaults))
    private lazy var remoteRepository = RemoteRepository(service: CurrencyService())
    private let result = PassthroughSubject<Void, CoordinatorError>()
    private var subscriptions = Set<AnyCancellable>()
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> AnyPublisher<Void, CoordinatorError> {
        
        let viewModel = CurrencyMainViewModel(repository: repository, selectedCurrency: currencyDefaults.selectedCurrency)
        let viewController = CurrencyMainViewController(viewModel: viewModel)

        
        root = UINavigationController(rootViewController: viewController)
        window.rootViewController = root
        window.makeKeyAndVisible()
        
        viewModel.openSupportedList.sink(receiveValue: { [unowned self] _ in
            self.navigateToSupportedList { (selected) in
                
                viewModel.selectCurrencySubject.send(selected)
            }
        })
        .store(in: &subscriptions)
      //  result.send(())
      //  result.send(completion: .finished)
      //  result.send(completion: .failure(.unknown))
        return result.eraseToAnyPublisher()
    }
    
    private func navigateToSupportedList(completion:@escaping (CurrencyModel) -> Void) {
        let viewModel = SupportedCurrenciesViewModel(currencies: currencyDefaults.currencies) { (result) in
            self.repository.saveSelectedCurrency(result)
            completion(result)
            self.root.popViewController(animated: true)
        }
        let viewController = SupportedCurrenciesViewController(viewModel: viewModel)
        root.pushViewController(viewController, animated: true)
        
        
    }
}
