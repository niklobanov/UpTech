//
//  ProductsResponse.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

struct ProductResponse: Codable {
    let productID: Int
    let mnnID: String
    let mnnName: String
    let mnnCode: String

    enum CodingKeys: String, CodingKey {
        case productID = "PRODUCT_ID"
        case mnnID = "MNN_ID"
        case mnnName = "MNN_NAME"
        case mnnCode = "MNN_CODE"
    }
}
