//
//  CoinsListView.swift
//  Coins
//
//  Created by kayeli dennis on 02/03/2025.
//

import UIKit
import Combine
import SwiftUI

class CoinsListView: UIViewController {

    // MARK: - Views

    lazy var tableView: UITableView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let tableView: UITableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var loader: UIActivityIndicatorView = {
        let loader: UIActivityIndicatorView = UIActivityIndicatorView(
            style: .large
        )
        loader.hidesWhenStopped = true
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    lazy var filterButton: UIBarButtonItem = {
        let image = UIImage(systemName: "line.3.horizontal.decrease")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(filter))
        return button
    }()

    // MARK: Dependencies

    let viewModel: CoinsListViewModel
    
    // MARK: Variables

    var cancellables: Set<AnyCancellable> = []
    var currentPage: Int = 0

    // MARK: - Initializer

    init(viewModel: CoinsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
        bind()
        title = "Coins"
        self.parent?.navigationItem.rightBarButtonItems = [filterButton]

        Task.detached { [weak self] in
            await self?.viewModel.fetchCoins()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func filter() {
        
    }
    // MARK: - Private methods

    private func bind() {
        viewModel.$state.sink { [weak self] state in
            switch state {
            case .loading:
                DispatchQueue.main.async {
                    self?.loader.startAnimating()
                }
            case .error(let message):
                self?.showAlert(
                    title: "Something went wrong!",
                    message: message
                )
            case .none:
                self?.reloadTableView() // stops animating as well
            }
        }.store(in: &cancellables)
        
        viewModel.$showFilter.sink { [weak self] show in
            if show {
                self?.showMenu()
            }
        }.store(in: &cancellables)
    }

    // Method to reload the table view on the main thread
    fileprivate func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            self?.loader.stopAnimating()
        }
    }
    
    fileprivate func showAlert(title: String, message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.loader.stopAnimating()
            self?.alert(title: title, message: message)
        }
    }
}

// MARK: - CoinsListView Collection view datasource

extension CoinsListView: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CoinsListViewCell.reuseIdentifier,
            for: indexPath
        ) as? CoinsListViewCell else {
            fatalError("Could not dequeue cell")
        }
        cell.configure(with: item)
        return cell
    }
}

extension CoinsListView: UITableViewDelegate {
    
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 60
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        let count = viewModel.numberOfItems() - 1
        if indexPath.row ==  count {
            guard
                viewModel.numberOfItems() < viewModel.totalCoins
                    && viewModel.shouldFetchMore else { return }
            Task.detached {[weak self] in await self?.viewModel.fetchCoins() }
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let contextItem = UIContextualAction(
            style: .normal,
            title: "Add To Favorites"
        ) {[weak self]  (contextualAction, view, completion) in
            withAnimation {
                self?.viewModel.addToFavourite(item: indexPath.row)
                self?.showAlert(title: "🚀", message: "Item added to your favourites")
                completion(true)
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        return swipeActions
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = CoinDetailViewModel(
            dependencies: .init(apiClient: viewModel.networkClient()),
            coinId: viewModel.item(at: indexPath.row).id
        )
        let viewController = UIHostingController(rootView: CoinDetailView(viewModel: viewModel))
        self.present(viewController, animated: true)
    }
}
