//
//  ApiProtocol.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

protocol APIService {
    var baseURL: String { get }
    var path: String { get }
    var method: Method { get }
    var headers: [String: String] { get }
    var parameters: [String: Any] { get }
}
