# Coins App
 An App that help browse through different crypto coins and track their performance. You can also favourite the coins that you like.
## Prerequisites
### How to run
1. Register an API Key with [CoinRank](https://developers.coinranking.com/api/documentation)
2. Copy the Key and in the app in the root folder find the `AppConfig` file.
3. Paste the key at `COIN_API_KEY`
4. The app has been built using `Xcode 16.2 (16C5032a)` and swift `6`
5. You should now be able to run the APP


## Architecture
1. The app has been built using MVVM Architeture with View Models holding the business logic
2. Dependency Management and Injection has been applied to power the viewModels for the resources they need to conduct their operations
3. Rudimentary tests have been written using Swift Testsing framework. (There could be more coverage)
4. The view layer couples both traces of UIKit and SwiftUI

## Things to improve on
1. Accessibility
2. Tests Coverage
3. Robust and more bulletproof way of handling the keys. Right now they are injected via Info plist but for securty we could obfuscate and employ Apples keychain.
4. Better Logging and tracking business metrics. This would need tools like sentry and mixpanel to help with observability and monitoring. 

