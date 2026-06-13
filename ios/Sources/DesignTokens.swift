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
