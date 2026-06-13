import SwiftUI
import WidgetKit

@main
struct MeAIWidgetBundle: WidgetBundle {
    var body: some Widget {
        MeAIOperatorStatusWidget()
    }
}

struct MeAIOperatorStatusWidget: Widget {
    let kind = "MeAIOperatorStatusWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MeAIStatusTimelineProvider()) { entry in
            MeAIStatusWidgetView(entry: entry)
                .containerBackground(for: .widget) {
                    LinearGradient(
                        colors: [Color(red: 0.04, green: 0.05, blue: 0.09), Color(red: 0.10, green: 0.14, blue: 0.22)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                }
        }
        .configurationDisplayName("Me.AI Operator")
        .description("Glance at operator readiness, call status, and pending confirmations.")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular, .accessoryInline])
    }
}

struct MeAIStatusEntry: TimelineEntry {
    let date: Date
    let readinessScore: Int
    let readinessTotal: Int
    let activeCallStatus: String
    let pendingConfirmations: Int
    let nextStep: String
}

struct MeAIStatusTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> MeAIStatusEntry {
        .preview
    }

    func getSnapshot(in context: Context, completion: @escaping (MeAIStatusEntry) -> Void) {
        completion(.preview)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<MeAIStatusEntry>) -> Void) {
        let entry = loadSharedStatus()
        completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(15 * 60))))
    }

    private func loadSharedStatus() -> MeAIStatusEntry {
        let defaults = UserDefaults(suiteName: "group.com.meai.shared")
        let readinessScore = defaults?.integer(forKey: "readinessScore") ?? MeAIStatusEntry.preview.readinessScore
        let readinessTotal = defaults?.integer(forKey: "readinessTotal") ?? MeAIStatusEntry.preview.readinessTotal
        let pendingConfirmations = defaults?.integer(forKey: "pendingConfirmations") ?? MeAIStatusEntry.preview.pendingConfirmations
        let activeCallStatus = defaults?.string(forKey: "activeCallStatus") ?? MeAIStatusEntry.preview.activeCallStatus
        let nextStep = defaults?.string(forKey: "readinessNextStep") ?? MeAIStatusEntry.preview.nextStep

        return MeAIStatusEntry(
            date: Date(),
            readinessScore: readinessScore,
            readinessTotal: max(readinessTotal, 1),
            activeCallStatus: activeCallStatus,
            pendingConfirmations: pendingConfirmations,
            nextStep: nextStep
        )
    }
}

struct MeAIStatusWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: MeAIStatusEntry

    var body: some View {
        switch family {
        case .accessoryInline:
            Text("Me.AI \(entry.readinessScore)/\(entry.readinessTotal) · \(entry.pendingConfirmations) approvals")
        case .accessoryRectangular:
            VStack(alignment: .leading, spacing: 3) {
                Text("Me.AI Operator")
                    .font(.headline)
                Text(entry.activeCallStatus)
                    .font(.caption)
                Text("\(entry.pendingConfirmations) confirmations")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        default:
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.cyan)
                    Text("Me.AI")
                        .font(.headline.bold())
                    Spacer()
                    Text("\(entry.readinessScore)/\(entry.readinessTotal)")
                        .font(.caption.bold())
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.white.opacity(0.12), in: Capsule())
                }

                Text(entry.activeCallStatus)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                if family == .systemMedium {
                    Text(entry.nextStep)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)

                HStack(spacing: 8) {
                    Label("\(entry.pendingConfirmations)", systemImage: "bell.badge.fill")
                    Text("pending approvals")
                }
                .font(.caption.bold())
                .foregroundStyle(.cyan)
            }
            .foregroundStyle(.white)
        }
    }
}

private extension MeAIStatusEntry {
    static let preview = MeAIStatusEntry(
        date: Date(),
        readinessScore: 5,
        readinessTotal: 8,
        activeCallStatus: "Operator ready to screen calls",
        pendingConfirmations: 2,
        nextStep: "Connect phone provider before TestFlight review"
    )
}

#Preview(as: .systemMedium) {
    MeAIOperatorStatusWidget()
} timeline: {
    MeAIStatusEntry.preview
}
