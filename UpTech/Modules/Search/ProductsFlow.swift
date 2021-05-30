//
//  ProductsFlow.swift
//  UpTech
//
//  Created by Nikita Lobanov on 30.05.2021.
//

import UIKit

enum ProductsFlow {
    static func makeProductsList() -> UIViewController {
        let viewModel = ProductsSearchViewModel()
        let viewController = ProductsViewController(viewModel: viewModel)
        return viewController
    }
}
