import Foundation
import CallKit

final class CallKitManager: NSObject {
    private let provider: CXProvider
    private let controller = CXCallController()

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
        provider.reportNewIncomingCall(with: id, update: update) { error in
            if let error { print("CallKit report failed: \(error.localizedDescription)") }
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
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) { action.fulfill() }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) { action.fulfill() }
}
