import Foundation
import Observation

@Observable
final class RealtimeVoiceService: AudioEngineDelegate {
    static let shared = RealtimeVoiceService()
    
    var isConnected = false
    var activeTranscript: String = "Connecting securely..."
    var currentEnergyLevel: Float = 0.0
    
    private var webSocketClient: OpenAIWebSocketClient?
    private let audioEngine = RealtimeAudioEngine()
    private let toolExecutor = NativeToolExecutor()
    
    private init() {
        audioEngine.delegate = self
    }
    
    func connect(token: String) {
        guard !isConnected else { return }
        
        webSocketClient = OpenAIWebSocketClient(token: token)
        webSocketClient?.onEvent = { [weak self] event in
            DispatchQueue.main.async {
                self?.handleEvent(event)
            }
        }
        
        webSocketClient?.connect()
        do {
            try audioEngine.start()
            isConnected = true
            activeTranscript = "Listening..."
        } catch {
            activeTranscript = "Microphone access error."
            print("Audio Engine Start Error: \(error.localizedDescription)")
        }
    }
    
    func disconnect() {
        webSocketClient?.disconnect()
        audioEngine.stop()
        isConnected = false
        activeTranscript = "Disconnected."
        currentEnergyLevel = 0.0
    }
    
    private func handleEvent(_ event: RealtimeEvent) {
        switch event {
        case .transcriptDelta(let delta):
            if activeTranscript == "Listening..." {
                activeTranscript = ""
            }
            activeTranscript += delta
        case .audioDelta(let pcmData):
            audioEngine.schedulePlayback(pcmData: pcmData)
        case .functionCall(let callId, let name, let arguments):
            handleFunctionCall(callId: callId, name: name, arguments: arguments)
        case .disconnected:
            disconnect()
        case .error(let error):
            activeTranscript = "Connection error."
            print("WebSocket Error: \(error.localizedDescription)")
        }
    }
    
    private func handleFunctionCall(callId: String, name: String, arguments: String) {
        Task {
            guard let toolName = NativeToolName(rawValue: name) else {
                webSocketClient?.sendFunctionOutput(callId: callId, result: "{\"status\": \"error\", \"message\": \"Unknown tool.\"}")
                return
            }
            
            var payload: [String: Any] = [:]
            if let data = arguments.data(using: .utf8),
               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                payload = json
            }
            
            let result = await toolExecutor.execute(name: toolName, payload: payload)
            
            if let resultData = try? JSONSerialization.data(withJSONObject: result),
               let resultString = String(data: resultData, encoding: .utf8) {
                webSocketClient?.sendFunctionOutput(callId: callId, result: resultString)
            }
        }
    }
    
    // MARK: - AudioEngineDelegate
    
    func audioEngine(_ engine: RealtimeAudioEngine, didCaptureAudioBuffer pcmData: Data) {
        webSocketClient?.sendAudio(pcmBuffer: pcmData)
    }
    
    func audioEngine(_ engine: RealtimeAudioEngine, didUpdateEnergyLevel level: Float) {
        self.currentEnergyLevel = level
    }
}
