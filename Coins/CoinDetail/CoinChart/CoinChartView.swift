//
//  CoinChartView.swift
//  Coins
//
//  Created by kayeli dennis on 06/03/2025.
//

import SwiftUI
import Charts

public struct CoinChartView: View {
    @ObservedObject var viewModel: CoinChartViewModel

    public var body: some View {
        VStack {
            if viewModel.state == .loading {
                ProgressView()
            } else if case let .error(message) = viewModel.state {
                Text("Sorry unable to get trend data: \(message)")
            } else {
                // filter buttons
                HStack(spacing: 5) {
                    ForEach(Models.CoinRank.API.Coin.TrendPeriod.allCases, id: \.self) { item in
                        Button(action: {
                            viewModel.updateTrendPeriod(item)
                        }) {
                            Text(item.rawValue)
                        }.background {
                            if viewModel.currentTrendPeriod == item {
                                Rectangle().fill(Color.blue.opacity(0.5))
                            }
                        }
                    }
                }

                trendChart()
            }
        }.task {
            await viewModel.fetchCoinHistory()
        }
    }

    @ViewBuilder
    func trendChart() -> some View {
        let chartData = viewModel.pricePoints()
        let minPrice: Double = {
            chartData.map { $0.price }.min() ?? 0
        }()
        
        let maxPrice: Double = {
            chartData.map { $0.price }.max() ?? 0
        }()
        Chart(chartData) { point in
            LineMark(
                x: .value("Time", point.timestamp),
                y: .value("Price", point.price)
            )
            .foregroundStyle(.blue)
            .lineStyle(StrokeStyle(lineWidth: 2))
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) // X-axis labels
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5)) { value in
                AxisGridLine()
                    .foregroundStyle(Color.gray.opacity(0.2))
                AxisValueLabel {
                    if let price = value.as(Double.self) {
                        Text(price, format: .number.precision(.fractionLength(2)))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .chartYScale(domain: minPrice...maxPrice)
        .frame(height: 200)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
