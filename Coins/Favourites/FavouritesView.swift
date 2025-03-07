//
//  FavouritesView.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

import SwiftUI
import SwiftData

struct FavouritesView: View {
    @Environment(\.modelContext) private var modelContext
    var viewModel: FavouritesViewModel
    @Query private var items: [FavouriteItem]

    var body: some View {
        NavigationStack {
            if items.isEmpty {
                VStack {
                    Text("You have no Favourites 😉")
                }
            } else {
                List {
                    ForEach(items) { item in
                        let viewModel = CoinDetailViewModel(
                            dependencies: .init(apiClient: viewModel.apiClient),
                            coinId: item.id
                        )
                        NavigationLink {
                            CoinDetailView(viewModel: viewModel)
                        }
                        label: {
                            CoinView(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    FavouritesView(viewModel: .init(apiClient: NetworkClient()))
        .modelContainer(for: FavouriteItem.self, inMemory: true)
}
