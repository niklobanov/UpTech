//
//  ProductsSearchViewModel.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Combine
import UIKit

struct ProductsSearchViewModelInput {
    /// called when a screen becomes visible
    let appear: AnyPublisher<Void, Never>
    // triggered when the search query is updated
    let search: AnyPublisher<String, Never>
    /// called when the user selected an item from the list
    let selection: AnyPublisher<Int, Never>
}

typealias ProductsSearchViewModelOuput = AnyPublisher<ProdcutsSearchState, Never>

protocol ProductSearchViewModelType {
    func transform(input: ProductsSearchViewModelInput) -> ProductsSearchViewModelOuput
}

final class ProductsSearchViewModel {
    private var cancellables: [AnyCancellable] = []
    private let productsAPI = ProductsAPI.shard

    func testRequest() {
        productsAPI.getProducts(queue: "").map { response in
            print(response.results)
        }.sink { _ in
        } receiveValue: { print($0) }.store(in: &cancellables)

    }
//    func transform(input: ProductsSearchViewModelInput) -> ProductsSearchViewModelOuput {
//        cancellables.forEach { $0.cancel() }
//        cancellables.removeAll()
//
//        input.selection
//            .sink(receiveValue: { [weak self] productId in
//                // Переход в детейл
//            })
//            .store(in: &cancellables)
//
//        let searchInput = input.search
//            .debounce(for: .milliseconds(300), scheduler: Scheduler.mainScheduler)
//            .removeDuplicates()
//        let movies = searchInput
//            .flatMap({ query in
//                self.productsAPI.getProducts()
//            }).map({ result -> ProdcutsSearchState in
//                if result.result.isEmpty {
//                    return .noResult
//                } else {
//                    return .succes(result.result)
//                }
//            })
//            .eraseToAnyPublisher()
//
//
//
//        let initialState: ProductsSearchViewModelOuput = .just(.idle)
//        let emptySearchString: ProductsSearchViewModelOuput = searchInput.filter({ $0.isEmpty }).map({ _ in .idle }).eraseToAnyPublisher()
//        let idle: ProductsSearchViewModelOuput = Publishers.Merge(initialState, emptySearchString).eraseToAnyPublisher()
//
//        return Publishers.Merge(idle, movies).removeDuplicates().eraseToAnyPublisher()
//    }
}
