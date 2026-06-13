import Foundation

struct AppConfiguration {
    let apiBaseURL: URL
    let isSampleDataEnabled: Bool

    static let local = AppConfiguration(
        apiBaseURL: URL(string: "http://127.0.0.1:8787")!,
        isSampleDataEnabled: true
    )

    static let production = AppConfiguration(
        apiBaseURL: URL(string: "https://api.me.ai")!,
        isSampleDataEnabled: false
    )
}
