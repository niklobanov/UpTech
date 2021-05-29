//
//  APIError.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

enum APIError: Swift.Error {
    case requestRejected(Error)
    case decodeFailed
    case statusCode(Int)
    case invalidPath
}
