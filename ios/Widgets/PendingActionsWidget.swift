import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), pendingCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), pendingCount: 1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // In a real implementation, we would query the AppGroup UserDefaults or CoreData for pending actions
        let entry = SimpleEntry(date: Date(), pendingCount: 2)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let pendingCount: Int
}

struct PendingActionsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(red: 10/255, green: 10/255, blue: 15/255) // Dark Ink background
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: "checkmark.shield.fill")
                        .foregroundStyle(Color(red: 99/255, green: 102/255, blue: 241/255)) // Indigo
                    Text("Me.AI")
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                if entry.pendingCount > 0 {
                    Text("\(entry.pendingCount) Actions Required")
                        .font(.subheadline.bold())
                        .foregroundStyle(.white)
                    Text("Open app to review security confirmations.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                } else {
                    Text("All Clear")
                        .font(.subheadline.bold())
                        .foregroundStyle(.green)
                    Text("No pending actions.")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .padding()
        }
    }
}

struct PendingActionsWidget: Widget {
    let kind: String = "PendingActionsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PendingActionsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Me.AI Actions")
        .description("Track pending security and capability confirmations.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
