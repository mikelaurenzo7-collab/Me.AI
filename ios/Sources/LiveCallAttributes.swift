import ActivityKit
import Foundation

public struct LiveCallAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        public var callerName: String
        public var activeTranscript: String
        public var isHandoffReady: Bool
        
        public init(callerName: String, activeTranscript: String, isHandoffReady: Bool) {
            self.callerName = callerName
            self.activeTranscript = activeTranscript
            self.isHandoffReady = isHandoffReady
        }
    }
    
    public var callId: String
    
    public init(callId: String) {
        self.callId = callId
    }
}
