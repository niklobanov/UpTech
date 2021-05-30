//
//  ProductsViewController.swift
//  UpTech
//
//  Created by Nikita Lobanov on 29.05.2021.
//

import UIKit
import Combine
import SwiftUI

enum Section: CaseIterable {
    case products
}

final class ProductsViewController: UIViewController {
    private var cancellables: [AnyCancellable] = []

    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<ProductResponse, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let viewModel: ProductSearchViewModelProtocol

    private lazy var dataSource = makeDataSource()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

    private lazy var idleView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "empty_icon")
        view.contentMode = .scaleAspectFit
        return view
    }()

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.tableFooterView = UIView()
        view.rowHeight = UITableView.automaticDimension
        view.registerClass(cellClass: ProductTableViewCell.self)
        return view
    }()

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.tintColor = .red
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()

    init(viewModel: ProductSearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not supported!")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.removeBackTitle()
    }

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        [tableView, activityIndicator, idleView].forEach(view.addSubview)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        idleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        bind(to: viewModel)

        self.navigationItem.titleView = self.searchController.searchBar;
        searchController.isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    private func bind(to viewModel: ProductSearchViewModelProtocol) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()

        let input = ProductsSearchViewModelInput(
            appear: appear.eraseToAnyPublisher(),
            search: search.eraseToAnyPublisher(),
            selection: selection.eraseToAnyPublisher()
        )

        let output = viewModel.transform(input: input)

        output.sink(receiveValue: {[unowned self] state in
            self.render(state)
        }).store(in: &cancellables)
    }

    private func render(_ state: ProdcutsSearchState) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = false
            idleView.isHidden = false
            update(with: [], animate: true)
        case .loading:
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            update(with: [], animate: true)
            tableView.isHidden = true
            idleView.isHidden = true
        case .noResults:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(with: [], animate: true)
            idleView.isHidden = true
            tableView.isHidden = false
        case .failure:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(with: [], animate: true)
            idleView.isHidden = true
            tableView.isHidden = false
        case .success(let movies):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            tableView.isHidden = false
            idleView.isHidden = true
            update(with: movies, animate: true)
        case .openProduct(let product):
            open(product)
        }
    }

    func open(_ productResponse: ProductResponse) {
        let detailView = DetailView(
            product: Product(productResponse: productResponse),
            analogues: productResponse.analogues?.map(Product.init) ?? []
        )
        let vc = UIHostingController(rootView: detailView)
        navigationController?.pushViewController(vc, animated: true)
    }
}

fileprivate extension ProductsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProductResponse> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, response in
                guard let cell = tableView.dequeueReusableCell(withClass: ProductTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(ProductTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.setup(response: response)
                return cell
            }
        )
    }

    func update(with products: [ProductResponse], animate: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductResponse>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(products, toSection: .products)
            self.dataSource.apply(snapshot, animatingDifferences: animate)
        }
    }
}

extension ProductsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search.send(searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        search.send("")
    }
}

extension ProductsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        selection.send(snapshot.itemIdentifiers[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}

