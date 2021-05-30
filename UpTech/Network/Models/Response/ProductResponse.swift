//
//  ProductsResponse.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

struct ProductResponse: Codable, Hashable {
    let sberProductId: Int?
    let name: String?
    let country: String?
    let dosage: String?
    let drugForm: String?
    let formName: String?
    let isRecipe: Bool?
    let manufacturer: String?
    let packing: String?
    let analogueIDs: [Int]?
    let price: String
    let detailPageURL: String?
    let medsisID: Int?
    let effectiveness: Int?
    let safety: Int?
    let convenience: Int?
    let sideEffects: Int?
    let tolerance: Int?
    let score: String?
    let isEffective: Bool?
    let isCheapest: Bool?
    let isTrustworthy: Bool?
    let imageURL: String?
    let analogues: [ProductResponse]?

    enum CodingKeys: String, CodingKey {
        case sberProductId = "sber_product_id"
        case name
        case country
        case dosage
        case drugForm = "drug_form"
        case formName = "form_name"
        case isRecipe = "is_recipe"
        case manufacturer
        case medsisID = "medsis_id"
        case packing
        case effectiveness
        case analogueIDs = "analogue_ids"
        case price
        case safety
        case convenience
        case tolerance
        case score
        case sideEffects = "side_effects"
        case isEffective = "is_effective"
        case isCheapest = "is_cheapest"
        case isTrustworthy = "is_trustworthy"
        case detailPageURL = "detail_page_url"
        case imageURL = "image_url"
        case analogues
    }
}
