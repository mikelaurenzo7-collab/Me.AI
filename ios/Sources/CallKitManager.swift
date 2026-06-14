import Foundation
import CallKit
import ActivityKit

final class CallKitManager: NSObject {
    private let provider: CXProvider
    private let controller = CXCallController()
    
    // Live Activity State
    private var currentActivity: Activity<LiveCallAttributes>?

    override init() {
        let config = CXProviderConfiguration(localizedName: "Me.AI")
        config.supportsVideo = false
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.phoneNumber]
        provider = CXProvider(configuration: config)
        super.init()
        provider.setDelegate(self, queue: nil)
    }

    func reportIncomingCall(id: UUID, handle: String, name: String?) {
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.localizedCallerName = name ?? "Me.AI Call"
        update.hasVideo = false
        provider.reportNewIncomingCall(with: id, update: update) { [weak self] error in
            if let error { 
                print("CallKit report failed: \(error.localizedDescription)") 
            } else {
                self?.startLiveActivity(id: id, name: update.localizedCallerName ?? handle)
            }
        }
    }
    
    // MARK: - Live Activities
    
    private func startLiveActivity(id: UUID, name: String) {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            do {
                let attributes = LiveCallAttributes(callId: id.uuidString)
                let contentState = LiveCallAttributes.ContentState(callerName: name, activeTranscript: "Connecting securely...", isHandoffReady: false)
                let activityContent = ActivityContent(state: contentState, staleDate: nil)
                
                currentActivity = try Activity.request(attributes: attributes, content: activityContent, pushType: nil)
            } catch {
                print("Failed to start Live Activity: \(error.localizedDescription)")
            }
        }
    }
    
    func updateCallTranscript(transcript: String, isHandoffReady: Bool = false) {
        Task {
            guard let activity = currentActivity else { return }
            var updatedState = activity.content.state
            updatedState.activeTranscript = transcript
            updatedState.isHandoffReady = isHandoffReady
            let updatedContent = ActivityContent(state: updatedState, staleDate: nil)
            
            await activity.update(updatedContent)
        }
    }
    
    private func endLiveActivity() {
        Task {
            guard let activity = currentActivity else { return }
            let finalState = activity.content.state
            let finalContent = ActivityContent(state: finalState, staleDate: nil)
            await activity.end(finalContent, dismissalPolicy: .immediate)
            currentActivity = nil
        }
    }

    func startCall(id: UUID, handle: String) {
        let action = CXStartCallAction(call: id, handle: CXHandle(type: .phoneNumber, value: handle))
        let transaction = CXTransaction(action: action)
        controller.request(transaction) { error in
            if let error { print("CallKit start failed: \(error.localizedDescription)") }
        }
    }
}

extension CallKitManager: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {}
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) { action.fulfill() }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) { 
        endLiveActivity()
        action.fulfill() 
    }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) { action.fulfill() }
}
