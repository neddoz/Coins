//
//  CoinsApp.swift
//  Coins
//
//  Created by kayeli dennis on 27/02/2025.
//

import SwiftUI
import SwiftData


@main
struct MainEntryPoint {
    static func main() {
        if isProduction() {
            CoinsApp.main()
        } else {
            TestApp.main()
        }
    }

    private static func isProduction() -> Bool {
        if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
            return true
        }
        return false
    }
}

struct CoinsApp: App {
    // MARK: Dependencies
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FavouriteItem.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var appDependencyManager: AppDependencyManagerProtocol = {
        let manager = AppDependencyManager()
        return manager
    }()

    var body: some Scene {
        WindowGroup {
            let dependencies = CoinsListViewModel.Dependencies(
                apiClient: appDependencyManager.apiClient,
                container: sharedModelContainer
            )
            let coinsListViewModel: CoinsListViewModel = CoinsListViewModel(dependencies: dependencies)
            let coinsListView = CoinsListView.UIKitViewControllerWrapper(
                viewModel: coinsListViewModel
            )

            TabView {
                NavigationStack {
                    coinsListView
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("", systemImage: "line.3.horizontal.decrease") {
                                    coinsListViewModel.showFilter.toggle()
                                }
                            }
                        }
                        .navigationTitle("Coins")
                }
                .tabItem {
                    Label("Coins", systemImage: "list.dash")
                }

                let favouritesViewModel = FavouritesViewModel(apiClient: appDependencyManager.apiClient)
                FavouritesView(viewModel: favouritesViewModel)
                    .navigationTitle("Favourites")
                    .tabItem {
                        Label("Favourites", systemImage: "star")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup {
        }
    }
}
