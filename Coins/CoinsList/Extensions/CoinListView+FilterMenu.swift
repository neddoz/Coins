//
//  CoinListView+FilterMenu.swift
//  Coins
//
//  Created by kayeli dennis on 05/03/2025.
//
import Foundation
import UIKit

extension CoinsListView {
    @objc func showMenu() {
        // Create the alert controller with action sheet style
        let alertController = UIAlertController(
            title: "Select an Option",
            message: nil,
            preferredStyle: .actionSheet
        )

        // Add actions for each menu item
        for (index, item) in Models.CoinRank.API.Coin.Filter.allCases.enumerated() {
            let preselectedIndex: Int = viewModel.preselectedFilterIndex
            // Add a checkmark to the preselected item
            let title = index == preselectedIndex ? "✓ \(item.title())" : item.title()
            let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
                // Handle selection
                self?.handleSelection(item: item.rawValue, at: index)
            }
            alertController.addAction(action)
        }
        // Add a Cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        // Present the alert
        present(alertController, animated: true, completion: nil)
    }
    
    func handleSelection(item: String, at index: Int) {
        viewModel.showFilter = false
        guard let filter = Models.CoinRank.API.Coin.Filter(rawValue: item) else {
            return
        }
        viewModel.updateFilterAndRefresh(filter)
    }
}
