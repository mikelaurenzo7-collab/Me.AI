import SwiftUI

enum MeAIDesign {
    static let cornerRadius: CGFloat = 24
    static let compactCornerRadius: CGFloat = 16
    static let spacing: CGFloat = 16
    static let largeSpacing: CGFloat = 24

    // Wireline "Dark Ink" Base
    static let darkInk = Color(red: 0.11, green: 0.05, blue: 0.19) // Deep space purple (#1C0D30)
    static let cardBackground = Color(white: 1.0, opacity: 0.03)
    static let editorialBorder = Color(white: 1.0, opacity: 0.12)
    
    // Wireline Brand Purple 
    static let primaryAccent = Color(red: 0.54, green: 0.25, blue: 0.84) // #8b3fd6
    static let secondaryAccent = Color(red: 0.42, green: 0.17, blue: 0.60) // #6b2b99
    
    // Text colors
    static let primaryText = Color.white
    static let secondaryText = Color.white.opacity(0.6)
    
    // Status colors
    static let success = Color(red: 0.06, green: 0.72, blue: 0.50) // #10b981
    static let destructive = Color(red: 0.95, green: 0.24, blue: 0.36) // #f43f5e
}

struct MeAIStatusChip: View {
    let title: String
    let detail: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).font(.headline).foregroundStyle(MeAIDesign.primaryText)
            Text(detail).font(.subheadline).foregroundStyle(MeAIDesign.secondaryText)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: MeAIDesign.compactCornerRadius, style: .continuous)
                .fill(MeAIDesign.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: MeAIDesign.compactCornerRadius, style: .continuous)
                .stroke(MeAIDesign.editorialBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

