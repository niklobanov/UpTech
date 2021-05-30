//
//  ProductsSearchViewModel.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Combine
import UIKit

struct ProductsSearchViewModelInput {
    let appear: AnyPublisher<Void, Never>
    let search: AnyPublisher<String, Never>
    let selection: AnyPublisher<ProductResponse, Never>
}

typealias ProductsSearchViewModelOuput = AnyPublisher<ProdcutsSearchState, Never>

protocol ProductSearchViewModelProtocol {
    func transform(input: ProductsSearchViewModelInput) -> ProductsSearchViewModelOuput
}

final class ProductsSearchViewModel: ProductSearchViewModelProtocol {
    private var cancellables = [AnyCancellable]()
    private var results = [ProductResponse]()
    private let productsAPI = ProductsAPI.shared

    func transform(input: ProductsSearchViewModelInput) -> ProductsSearchViewModelOuput {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let selectionProcessing = input.selection
            .map({ product -> ProdcutsSearchState in
                return .openProduct(product)
            })
            .eraseToAnyPublisher()

        let searchInput = input.search
            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
            .removeDuplicates()

        let movies = searchInput
            .filter { !$0.isEmpty }
            .flatMapLatest { [unowned self] query in self.productsAPI.getProducts(queue: query) }
            .map({ response -> ProdcutsSearchState in
                switch response {
                case .success(let response) where response.results.isEmpty : return .noResults
                case .success(let response): return .success(response.results)
                case .failure(let error): return .failure(error)
                }
            })
            .eraseToAnyPublisher()


        let initialState: ProductsSearchViewModelOuput = .just(.idle)
        let emptySearchString: ProductsSearchViewModelOuput = searchInput
            .filter({ $0.isEmpty })
            .map({ _ in .idle })
            .eraseToAnyPublisher()
        let idle: ProductsSearchViewModelOuput = Publishers.Merge(initialState, emptySearchString)
            .eraseToAnyPublisher()

        return Publishers.Merge3(idle, movies, selectionProcessing)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
}
