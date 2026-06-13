import Foundation

struct AppConfiguration {
    let apiBaseURL: URL
    let isSampleDataEnabled: Bool

    static let local = AppConfiguration(
        apiBaseURL: URL(string: "http://localhost:3000")!,
        isSampleDataEnabled: true
    )

    static let production = AppConfiguration(
        apiBaseURL: URL(string: "https://api.me.ai")!,
        isSampleDataEnabled: false
    )
}
