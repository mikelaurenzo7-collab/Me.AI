import AVFoundation
import Foundation
import Observation

@Observable
final class AudioPlaybackService {
    static let shared = AudioPlaybackService()
    
    var player: AVPlayer?
    var isPlaying = false
    var currentItemDuration: Double = 0.0
    var currentPlaybackTime: Double = 0.0
    var playbackRate: Float = 1.0
    var activeUrl: URL?

    private var timeObserverToken: Any?
    
    private init() {}
    
    func load(url: URL) {
        if activeUrl == url { return }
        
        stop()
        activeUrl = url
        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.rate = playbackRate
        
        // Duration observer
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.isPlaying = false
            self?.currentPlaybackTime = 0
            self?.player?.seek(to: .zero)
        }
        
        // Progress observer
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self else { return }
            self.currentPlaybackTime = time.seconds
            if let duration = self.player?.currentItem?.duration.seconds, !duration.isNaN {
                self.currentItemDuration = duration
            }
        }
    }
    
    func play() {
        guard let player else { return }
        player.play()
        player.rate = playbackRate
        isPlaying = true
    }
    
    func pause() {
        player?.pause()
        isPlaying = false
    }
    
    func stop() {
        pause()
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        player = nil
        activeUrl = nil
        currentPlaybackTime = 0.0
        currentItemDuration = 0.0
    }
    
    func seek(to seconds: Double) {
        let time = CMTime(seconds: seconds, preferredTimescale: 1000)
        player?.seek(to: time)
    }
    
    func setRate(_ rate: Float) {
        playbackRate = rate
        if isPlaying {
            player?.rate = rate
        }
    }
}
