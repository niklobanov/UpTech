//
//  ProductsAPI.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation
import Combine

enum ProductsAPIService {
    case getProducts
    case search(queue: String)
}

extension ProductsAPIService: APIService {
    var baseURL: String {
        ""
    }

    var path: String {
        ""
    }

    var method: Method {
        .get
    }

    var headers: [String : String] {
        ["content-Type": "application/json"]
    }

    var parameters: [String : Any] {
        switch self {
        case .search(let queue):
            return ["name": queue]
        default:
            return [:]
        }
    }
}

final class ProductsAPI {
    static let shard = ProductsAPI()
    private let productsAPI = API<ProductsAPIService>()

    func getProducts() -> AnyPublisher<ListResponse<ProductResponse>, APIError> {
        self.productsAPI.call(endpoint: .getProducts)
    }
}
