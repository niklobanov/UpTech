//
//  ProductsResponse.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

struct ProductResponse: Codable, Hashable {
    let sberProductId: Int
    let name: String
    let country: String
    let dosage: String
    let drugForm: String
    let formName: String
    let isRecipe: Bool
    let manufacturer: String
    let packing: String

    enum CodingKeys: String, CodingKey {
        case sberProductId = "sber_product_id"
        case name
        case country
        case dosage
        case drugForm = "drug_form"
        case formName = "form_name"
        case isRecipe = "is_recipe"
        case manufacturer
        case packing
    }
}
