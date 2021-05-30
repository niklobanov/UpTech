//
//  ProdcutsSearchState.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

enum ProdcutsSearchState {
    case noResults
    case idle
    case success([ProductResponse])
    case loading
    case failure(Error)
}

extension ProdcutsSearchState: Equatable {
    static func == (lhs: ProdcutsSearchState, rhs: ProdcutsSearchState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle): return true
        case (.loading, .loading): return true
        case (.success(let lhsResponse), .success(let rhsResponse)): return lhsResponse == rhsResponse
        case (.noResults, .noResults): return true
        case (.failure, .failure): return true
        default: return false
        }
    }
}
