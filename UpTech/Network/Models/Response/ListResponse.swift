//
//  ListResponse.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    let next: String?
    let previous: String?
    let result: [T]
}
