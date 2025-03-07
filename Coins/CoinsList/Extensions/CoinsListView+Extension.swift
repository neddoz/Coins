//
//  CoinsListView+Extension.swift
//  Coins
//
//  Created by kayeli dennis on 03/03/2025.
//
import SwiftUI
import UIKit

extension CoinsListView {
    struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
        let viewModel: CoinsListViewModel
        typealias UIViewControllerType = CoinsListView

        // Step 1b: Required methods implementation
        func makeUIViewController(context: Context) -> CoinsListView {
            // Step 1c: Instantiate and return the UIKit view controller
            return CoinsListView(viewModel: viewModel)
        }

        func updateUIViewController(_ uiViewController: CoinsListView, context: Context) {
            // Update the view controller if needed
        }
    }
    
    func setUPUI() {
        tableView.register(CoinsListViewCell.self, forCellReuseIdentifier: CoinsListViewCell.reuseIdentifier)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    class CoinsListViewCell: UITableViewCell {
        static var reuseIdentifier = "CoinsListViewCell"

        private var item: Models.Core.Coin?

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            self.setupView()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupView() {
            guard let item = self.item else { return }
            let host = UIHostingController(rootView: CoinView(item: item))
            host.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(host.view)
            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }

        func configure(with item: Models.Core.Coin) {
            self.item = item
            setupView()
        }
    }
}
