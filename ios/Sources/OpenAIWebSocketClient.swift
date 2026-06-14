import Foundation

enum RealtimeEvent {
    case transcriptDelta(String)
    case audioDelta(Data)
    case functionCall(callId: String, name: String, arguments: String)
    case error(Error)
    case disconnected
}

final class OpenAIWebSocketClient: NSObject, URLSessionWebSocketDelegate {
    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let token: String
    
    var onEvent: ((RealtimeEvent) -> Void)?
    
    init(token: String) {
        self.token = token
        let config = URLSessionConfiguration.default
        self.session = URLSession(configuration: config)
        super.init()
    }
    
    func connect() {
        guard let url = URL(string: "wss://api.openai.com/v1/realtime") else { return }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("realtime=v1", forHTTPHeaderField: "OpenAI-Beta")
        
        webSocketTask = session.webSocketTask(with: request)
        webSocketTask?.delegate = self
        webSocketTask?.resume()
        
        // Initial configuration payload
        let configEvent: [String: Any] = [
            "type": "session.update",
            "session": [
                "modalities": ["audio", "text"],
                "instructions": "You are Me.AI, a protective personal assistant screening a call.",
                "tools": [
                    [
                        "type": "function",
                        "name": "route_to_location",
                        "description": "Opens Apple Maps and routes the user to a specific destination.",
                        "parameters": [
                            "type": "object",
                            "properties": [
                                "destination": ["type": "string", "description": "The destination address or name."]
                            ],
                            "required": ["destination"]
                        ]
                    ],
                    [
                        "type": "function",
                        "name": "create_calendar_reminder",
                        "description": "Creates a reminder in the user's Apple Reminders app.",
                        "parameters": [
                            "type": "object",
                            "properties": [
                                "title": ["type": "string", "description": "The title or subject of the reminder."]
                            ],
                            "required": ["title"]
                        ]
                    ]
                ]
            ]
        ]
        send(json: configEvent)
        
        receive()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
    }
    
    func sendAudio(pcmBuffer: Data) {
        let base64String = pcmBuffer.base64EncodedString()
        let event: [String: Any] = [
            "type": "input_audio_buffer.append",
            "audio": base64String
        ]
        send(json: event)
    }
    
    func sendFunctionOutput(callId: String, result: String) {
        let event: [String: Any] = [
            "type": "conversation.item.create",
            "item": [
                "type": "function_call_output",
                "call_id": callId,
                "output": result
            ]
        ]
        send(json: event)
        
        let responseEvent: [String: Any] = [
            "type": "response.create"
        ]
        send(json: responseEvent)
    }
    
    private func send(json: [String: Any]) {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let string = String(data: data, encoding: .utf8) else { return }
        let message = URLSessionWebSocketTask.Message.string(string)
        webSocketTask?.send(message) { error in
            if let error { print("WebSocket Send Error: \(error.localizedDescription)") }
        }
    }
    
    private func receive() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let message):
                self.handleMessage(message)
                self.receive() // recursive listening
            case .failure(let error):
                self.onEvent?(.error(error))
                self.onEvent?(.disconnected)
            }
        }
    }
    
    private func handleMessage(_ message: URLSessionWebSocketTask.Message) {
        switch message {
        case .string(let text):
            guard let data = text.data(using: .utf8),
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let type = json["type"] as? String else { return }
            
            switch type {
            case "response.audio.delta":
                if let deltaStr = json["delta"] as? String, let audioData = Data(base64Encoded: deltaStr) {
                    onEvent?(.audioDelta(audioData))
                }
            case "response.audio_transcript.delta":
                if let deltaStr = json["delta"] as? String {
                    onEvent?(.transcriptDelta(deltaStr))
                }
            case "response.function_call.arguments.done":
                if let callId = json["call_id"] as? String,
                   let name = json["name"] as? String,
                   let arguments = json["arguments"] as? String {
                    onEvent?(.functionCall(callId: callId, name: name, arguments: arguments))
                }
            default:
                break // Ignoring other events for brevity
            }
        case .data(_):
            break
        @unknown default:
            break
        }
    }
    
    // MARK: - URLSessionWebSocketDelegate
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        onEvent?(.disconnected)
    }
}
