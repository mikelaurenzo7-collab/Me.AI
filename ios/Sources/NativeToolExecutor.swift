import EventKit
import Foundation
import MapKit
import UIKit

enum NativeToolName: String {
    case routeToLocation = "route_to_location"
    case createCalendarReminder = "create_calendar_reminder"
    case handoffMusicRequest = "handoff_music_request"
    case sendMessageDraft = "send_message_draft"
    case requestUserConfirmation = "request_user_confirmation"
}

@MainActor
final class NativeToolExecutor {
    func execute(name: NativeToolName, payload: [String: Any]) async -> [String: Any] {
        switch name {
        case .routeToLocation:
            return await route(payload: payload)
        case .createCalendarReminder:
            return await createReminder(payload: payload)
        case .handoffMusicRequest:
            return ["status": "handoff_required", "message": "Use approved media integrations or Shortcuts allowlist."]
        case .sendMessageDraft:
            return ["status": "draft_only", "message": "Message draft requires user confirmation before sending."]
        case .requestUserConfirmation:
            return ["status": "confirmation_required"]
        }
    }

    private func route(payload: [String: Any]) async -> [String: Any] {
        guard let destination = payload["destination"] as? String else { return ["status": "missing_destination"] }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = destination
        do {
            let response = try await MKLocalSearch(request: request).start()
            guard let item = response.mapItems.first else { return ["status": "not_found"] }
            item.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
            return ["status": "opened_maps"]
        } catch {
            return ["status": "failed", "error": error.localizedDescription]
        }
    }

    private func createReminder(payload: [String: Any]) async -> [String: Any] {
        guard let title = payload["title"] as? String else { return ["status": "missing_title"] }
        let store = EKEventStore()
        do {
            try await store.requestFullAccessToReminders()
            let reminder = EKReminder(eventStore: store)
            reminder.title = title
            reminder.calendar = store.defaultCalendarForNewReminders()
            try store.save(reminder, commit: true)
            return ["status": "created"]
        } catch {
            return ["status": "failed", "error": error.localizedDescription]
        }
    }
}
