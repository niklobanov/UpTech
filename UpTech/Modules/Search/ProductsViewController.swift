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
    private var cancellables: [AnyCancellable] = []

    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let viewModel: ProductSearchViewModelProtocol

    private lazy var dataSource = makeDataSource()

    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)

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
        searchController.searchBar.tintColor = .label
        searchController.searchBar.delegate = self
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

    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        [tableView, activityIndicator].forEach(view.addSubview)

        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        definesPresentationContext = true

        bind(to: viewModel)
        navigationItem.searchController = self.searchController
        searchController.isActive = true

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }

    private func bind(to viewModel: ProductSearchViewModelProtocol) {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        let input = ProductsSearchViewModelInput(appear: appear.eraseToAnyPublisher(),
                                               search: search.eraseToAnyPublisher(),
                                               selection: selection.eraseToAnyPublisher())

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
            update(with: [], animate: true)
        case .loading:
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            update(with: [], animate: true)
        case .noResults:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(with: [], animate: true)
        case .failure:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(with: [], animate: true)
        case .success(let movies):
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            update(with: movies, animate: true)
        }
    }
}

fileprivate extension ProductsViewController {
    func makeDataSource() -> UITableViewDiffableDataSource<Section, ProductResponse> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, movieViewModel in
                guard let cell = tableView.dequeueReusableCell(withClass: ProductTableViewCell.self) else {
                    assertionFailure("Failed to dequeue \(ProductTableViewCell.self)!")
                    return UITableViewCell()
                }
                cell.setup()
                return cell
            }
        )
    }

    func update(with movies: [ProductResponse], animate: Bool = true) {
        print(movies)
        DispatchQueue.main.async {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ProductResponse>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(movies, toSection: .products)
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
        selection.send(snapshot.itemIdentifiers[indexPath.row].sberProductId ?? 0)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
}

