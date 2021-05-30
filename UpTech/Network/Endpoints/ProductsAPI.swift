//
//  ProductsAPI.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation
import Combine

enum ProductsAPIService {
    case getProducts(queue: String)
    case getProduct(id: String)
}

extension ProductsAPIService: APIService {
    var baseURL: String {
        "http://uptech-stage.herokuapp.com/api/v1"
    }

    var path: String {
        switch self {
        case .getProduct(let id):
            return "/products/\(id)/"
        case .getProducts:
            return "/products/search/"
        }
    }

    var method: Method {
        .get
    }

    var headers: [String : String] {
        ["content-Type": "application/json"]
    }

    var parameters: [String : Any] {
        switch self {
        case .getProducts(let queue):
            return ["name": queue]
        default:
            return [:]
        }
    }
}

final class ProductsAPI {
    static let shared = ProductsAPI()
    private let productsAPI = API<ProductsAPIService>()

    func getProducts(queue: String) -> AnyPublisher<Result<ListResponse<ProductResponse>, APIError>, Never> {
       return self.productsAPI.call(endpoint: .getProducts(queue: queue))
        .map { .success($0) }
        .catch { error -> AnyPublisher<Result<ListResponse<ProductResponse>, APIError>, Never> in .just(.failure(error)) }
        .subscribe(on: Scheduler.backgroundWorkScheduler)
        .receive(on: Scheduler.mainScheduler)
        .eraseToAnyPublisher()
    }

    func getProduct(id: String) -> AnyPublisher<ProductResponse, APIError> {
        return self.productsAPI.call(endpoint: .getProduct(id: id))
    }
}
