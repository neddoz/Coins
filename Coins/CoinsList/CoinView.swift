//
//  CoinView.swift
//  Coins
//
//  Created by kayeli dennis on 02/03/2025.
//
import SwiftUI


struct CoinView: View {
    // MARK: - Dependencies

    @State var item: any CoinViewItem

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.iconUrl)) { image in
                image
                    .resizable()
                    .frame(width: 40, height: 40)
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image(systemName: "photo.fill")
            }
            .frame(width: 40, height: 40)

            // Name and Symbol
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.caption)
                Text(item.symbol)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Trend / change in price
            VStack {
                Text("\(item.price)")
                    .font(.caption)

                HStack {
                    Text("\(item.change)%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    let isDown: Bool = item.change.first == "-"
                    Image(
                        systemName: isDown ? "arrow.down.circle" : "arrow.up.circle"
                    )
                        .foregroundColor(isDown ? .red : .green)
                }
            }
        }
    }
}

extension CoinView {
    public protocol CoinViewItem: Identifiable {
        var id: String {get}
        var name: String {get}
        var symbol: String {get}
        var price: String {get}
        var change: String{get}
        var rank: Int{get}
        var color: String{get}
        var iconUrl: String{get}
    }
}

#Preview {
    let item: Models.Core.Coin = Models.Core.Coin.init(id: "xcodgg", name: "BTC", symbol: "$B", price: "1000", change: "-0.002", rank: 1, color: "4287f5", iconUrl: "https://example.com")
    CoinView(item: item)
}
