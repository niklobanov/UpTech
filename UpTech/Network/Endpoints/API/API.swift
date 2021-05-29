//
//  Endpoint.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation
import Combine

final class API<Endpoint: APIService> {
    private let jsonDecoder = JSONDecoder()
    private let requestBuilder: RequestBuilder<Endpoint>

    init(requestBuilder: RequestBuilder<Endpoint> = RequestBuilder()) {
        self.requestBuilder = requestBuilder
    }

    private func request(endpoint: Endpoint) -> URLRequest {
        let path = requestBuilder.formUrlPath(from: endpoint)
        guard let url = URL(string: path) else {
            preconditionFailure("bad url")
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = requestBuilder.formHeaders(from: endpoint)
        endpoint.parameters.forEach { request.addValue("\($0.value)", forHTTPHeaderField: $0.key) }

        print("request created: path = \(path)\n\tmethod = \(endpoint.method)\n\tparams = \(String(describing: endpoint.parameters))")
        return request
    }

    func call<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        let urlRequest = request(endpoint: endpoint)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in APIError.requestRejected(error) }
            .map { $0.data }
            .decode(type: T.self, decoder: self.jsonDecoder)
            .mapError { _ in APIError.decodeFailed }
            .eraseToAnyPublisher()
    }
}
