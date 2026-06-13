import SwiftUI

enum MeAIDesign {
    static let cornerRadius: CGFloat = 24
    static let compactCornerRadius: CGFloat = 16
    static let spacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24

    static let appBackground = Color(.systemGroupedBackground)
    static let cardBackground = Color(.secondarySystemGroupedBackground)
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    static let accent = Color.accentColor

    static let darkInk = Color(red: 0.05, green: 0.05, blue: 0.07)
    static let primaryAccent = Color(red: 0.4, green: 0.5, blue: 1.0)
    static let secondaryAccent = Color(red: 0.7, green: 0.4, blue: 1.0)
}

struct MeAIStatusChip: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline)
            Text(detail).font(.subheadline).foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(MeAIDesign.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: MeAIDesign.compactCornerRadius, style: .continuous))
    }
}
