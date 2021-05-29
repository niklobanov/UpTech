//
//  ProductsViewController.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit
import Combine

enum Section: CaseIterable {
    case products
}

final class ProductsViewController: UIViewController {
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private lazy var dataSource = makeDataSource()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        tableView.dataSource = dataSource
        tableView.register(cellClass: ProductTableViewCell.self)
        return tableView
    }()
}

fileprivate extension ProductsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProductResponse> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                let cell: ProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
                cell.setup()
                return cell
            }
        )
    }

    func update(with movies: [ProductResponse], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductResponse>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }

}



