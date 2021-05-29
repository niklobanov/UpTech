//
//  RequestBuilder.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

protocol RequestBuilderProtocol {
    associatedtype Endpoint: APIService
    func formUrlPath(from endpoint: Endpoint) -> String
    func formHeaders(from endpoint: Endpoint) -> [String: String]
}

final class RequestBuilder<Endpoint: APIService>: RequestBuilderProtocol {
    private let authHeaderKey = "X-Authorization"

    func formUrlPath(from endpoint: Endpoint) -> String {
        return endpoint.baseURL + endpoint.path
    }

    func formHeaders(from endpoint: Endpoint) -> [String: String] {
        return endpoint.headers
    }
}
