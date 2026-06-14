import ActivityKit
import WidgetKit
import SwiftUI

struct LiveCallActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveCallAttributes.self) { context in
            // Lock Screen / Banner UI
            ZStack {
                Color(red: 10/255, green: 10/255, blue: 15/255)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "waveform.circle.fill")
                            .foregroundStyle(Color.green)
                        Text("Screening: \(context.state.callerName)")
                            .font(.subheadline.bold())
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Live")
                            .font(.caption2.bold())
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green.opacity(0.2))
                            .foregroundStyle(.green)
                            .clipShape(Capsule())
                    }
                    
                    Text(context.state.activeTranscript)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        
                    if context.state.isHandoffReady {
                        HStack {
                            Spacer()
                            Text("Take over call")
                                .font(.caption.bold())
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color(red: 99/255, green: 102/255, blue: 241/255))
                                .foregroundStyle(.white)
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding()
            }
            .activityBackgroundTint(Color.black.opacity(0.8))
            .activitySystemActionForegroundColor(Color.white)
            
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "waveform")
                        .foregroundStyle(.green)
                        .padding(.leading, 8)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Live")
                        .font(.caption2.bold())
                        .foregroundStyle(.green)
                        .padding(.trailing, 8)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text(context.state.callerName)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text(context.state.activeTranscript)
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }
            } compactLeading: {
                Image(systemName: "waveform")
                    .foregroundStyle(.green)
            } compactTrailing: {
                Text("Me.AI")
                    .font(.caption2.bold())
                    .foregroundStyle(.white)
            } minimal: {
                Image(systemName: "waveform")
                    .foregroundStyle(.green)
            }
        }
    }
}
