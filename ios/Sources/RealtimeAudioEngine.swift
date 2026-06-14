import AVFoundation
import Foundation

protocol AudioEngineDelegate: AnyObject {
    func audioEngine(_ engine: RealtimeAudioEngine, didCaptureAudioBuffer pcmData: Data)
    func audioEngine(_ engine: RealtimeAudioEngine, didUpdateEnergyLevel level: Float)
}

final class RealtimeAudioEngine {
    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let renderFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 24000, channels: 1, interleaved: false)!
    
    weak var delegate: AudioEngineDelegate?
    private var isRecording = false
    
    init() {
        setupEngine()
    }
    
    private func setupEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: renderFormat)
        engine.prepare()
    }
    
    func start() throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetooth])
        try audioSession.setActive(true)
        
        let inputNode = engine.inputNode
        let inputFormat = inputNode.inputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] buffer, time in
            guard let self = self, self.isRecording else { return }
            
            // Convert buffer to OpenAI's required format (16-bit PCM, 24kHz, Mono)
            if let convertedBuffer = self.convert(buffer: buffer, from: inputFormat, to: self.renderFormat),
               let pcmData = self.toData(buffer: convertedBuffer) {
                
                self.delegate?.audioEngine(self, didCaptureAudioBuffer: pcmData)
                
                // Calculate RMS energy for UI visualization
                let energy = self.calculateRMS(buffer: convertedBuffer)
                DispatchQueue.main.async {
                    self.delegate?.audioEngine(self, didUpdateEnergyLevel: energy)
                }
            }
        }
        
        try engine.start()
        playerNode.play()
        isRecording = true
    }
    
    func stop() {
        isRecording = false
        engine.inputNode.removeTap(onBus: 0)
        playerNode.stop()
        engine.stop()
        
        try? AVAudioSession.sharedInstance().setActive(false)
    }
    
    func schedulePlayback(pcmData: Data) {
        guard let pcmBuffer = toPCMBuffer(data: pcmData, format: renderFormat) else { return }
        playerNode.scheduleBuffer(pcmBuffer, at: nil, options: [], completionHandler: nil)
    }
    
    // MARK: - Utilities
    
    private func convert(buffer: AVAudioPCMBuffer, from inputFormat: AVAudioFormat, to outputFormat: AVAudioFormat) -> AVAudioPCMBuffer? {
        guard let converter = AVAudioConverter(from: inputFormat, to: outputFormat) else { return nil }
        guard let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: AVAudioFrameCount(outputFormat.sampleRate) * buffer.frameLength / AVAudioFrameCount(inputFormat.sampleRate)) else { return nil }
        
        var error: NSError?
        let inputBlock: AVAudioConverterInputBlock = { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }
        
        converter.convert(to: convertedBuffer, error: &error, withInputFrom: inputBlock)
        return error == nil ? convertedBuffer : nil
    }
    
    private func toData(buffer: AVAudioPCMBuffer) -> Data? {
        let channelCount = 1
        let channels = UnsafeBufferPointer(start: buffer.int16ChannelData, count: channelCount)
        let ch0Data = NSData(bytes: channels[0], length:Int(buffer.frameCapacity * buffer.format.streamDescription.pointee.mBytesPerFrame))
        return ch0Data as Data
    }
    
    private func toPCMBuffer(data: Data, format: AVAudioFormat) -> AVAudioPCMBuffer? {
        let streamDesc = format.streamDescription.pointee
        let frameCapacity = UInt32(data.count) / streamDesc.mBytesPerFrame
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCapacity) else { return nil }
        
        buffer.frameLength = buffer.frameCapacity
        let audioBuffer = buffer.audioBufferList.pointee.mBuffers
        
        data.withUnsafeBytes { rawBufferPointer in
            if let baseAddress = rawBufferPointer.baseAddress {
                audioBuffer.mData?.copyMemory(from: baseAddress, byteCount: Int(audioBuffer.mDataByteSize))
            }
        }
        return buffer
    }
    
    private func calculateRMS(buffer: AVAudioPCMBuffer) -> Float {
        guard let channelData = buffer.int16ChannelData?[0] else { return 0 }
        let frames = Int(buffer.frameLength)
        var sumSquares: Float = 0.0
        
        for i in 0..<frames {
            let sample = Float(channelData[i]) / 32768.0
            sumSquares += sample * sample
        }
        
        let rms = sqrt(sumSquares / Float(frames))
        return rms
    }
}
