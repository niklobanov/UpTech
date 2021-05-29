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

        var urlCompontents = URLComponents(string: path)
        urlCompontents?.queryItems = endpoint.parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        guard let url = urlCompontents?.url else {
            preconditionFailure("bad url")
        }

        var request = URLRequest(url: url)

        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = requestBuilder.formHeaders(from: endpoint)

        print("request created: path = \(path)\n\tmethod = \(endpoint.method)\n\tparams = \(String(describing: endpoint.parameters))")
        return request
    }

    func call<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        let urlRequest = request(endpoint: endpoint)
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .mapError { error in APIError.requestRejected(error) }
            .map { data in
                print(String(data: data.data, encoding: .utf8))
                return data.data
            }
            .decode(type: T.self, decoder: self.jsonDecoder)
            .mapError { _ in
                print("decode error")
                return APIError.decodeFailed
            }
            .eraseToAnyPublisher()
    }
}
