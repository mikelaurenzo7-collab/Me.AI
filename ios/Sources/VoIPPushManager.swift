import Foundation
import PushKit
import CallKit

final class VoIPPushManager: NSObject {
    static let shared = VoIPPushManager()
    
    private var pushRegistry: PKPushRegistry?
    
    // We will loosely couple this so the manager can forward payloads to CallKitManager
    var onIncomingCall: ((UUID, String, String?) -> Void)?
    
    private override init() {
        super.init()
    }
    
    func start() {
        // Initialize the PushRegistry on the main queue
        pushRegistry = PKPushRegistry(queue: .main)
        pushRegistry?.delegate = self
        
        // We only request VoIP type
        pushRegistry?.desiredPushTypes = [.voIP]
    }
}

extension VoIPPushManager: PKPushRegistryDelegate {
    
    // Called when the device successfully registers with Apple's APNs and gets a token
    func pushRegistry(_ registry: PKPushRegistry, didUpdatePushCredentials credentials: PKPushCredentials, for type: PKPushType) {
        let tokenString = credentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        print("VoIP Push Token successfully generated: \(tokenString)")
        
        // In a real production app, this is where you'd send `tokenString` to your backend via APIClient
    }
    
    // Called when the PushRegistry receives an incoming VoIP push notification from the backend
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("Incoming VoIP Push Received!")
        
        // Extract call metadata from the push payload (custom to your backend JSON)
        guard let dictionary = payload.dictionaryPayload as? [String: Any],
              let callIdString = dictionary["call_id"] as? String,
              let callId = UUID(uuidString: callIdString),
              let callerHandle = dictionary["caller_handle"] as? String else {
            completion()
            return
        }
        
        let callerName = dictionary["caller_name"] as? String
        
        // Critically important: Apple requires CallKit to be notified IMMEDIATELY inside this exact method.
        onIncomingCall?(callId, callerHandle, callerName)
        
        // Signal to iOS that we successfully processed the push
        completion()
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("VoIP Push Token Invalidated.")
    }
}
