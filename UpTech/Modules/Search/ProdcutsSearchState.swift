//
//  ProdcutsSearchState.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import Foundation

enum ProdcutsSearchState {
    case noResult
    case idle
    case succes([ProductResponse])
    case loading
    case failure(Error)
}
