import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager() 
    private var audioPlayer: AVAudioPlayer?
    private var backgroundMusicPlayer: AVAudioPlayer?
    private var soundEffects: [String: AVAudioPlayer] = [:] 
    
    private init() {
        preloadSoundEffects()
    }
    
    // Preloads specific sound effects
    private func preloadSoundEffects() {
        preloadSoundEffect(name: "clicksound", type: "mp3")
        preloadSoundEffect(name: "backgroundmusic", type: "mp3")
        
    }
    
    // Preloads a single sound effect
    private func preloadSoundEffect(name: String, type: String = "mp3") {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: type) else { return }
        let soundURL = URL(fileURLWithPath: bundlePath)
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.prepareToPlay() 
            soundEffects[name] = player
        } catch {
            print("Couldn't preload sound effect: \(error.localizedDescription)")
        }
    }
    
    func playSoundEffect(name: String) {
        if let player = soundEffects[name] {
            player.play()
        } else {
            print("Sound not preloaded, loading now: \(name)")
            loadAndPlaySoundEffect(name: name)
        }
    }
    
    private func loadAndPlaySoundEffect(name: String, type: String = "mp3") {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: type) else { return }
        let soundURL = URL(fileURLWithPath: bundlePath)
        
        do {
            let player = try AVAudioPlayer(contentsOf: soundURL)
            player.play()
            soundEffects[name] = player
        } catch {
            print("Couldn't play sound effect: \(error.localizedDescription)")
        }
    }
    
    // Plays background music with an option to loop indefinitely
    func playBackgroundMusic(name: String, type: String = "mp3") {
        guard let bundlePath = Bundle.main.path(forResource: name, ofType: type) else { return }
        let musicURL = URL(fileURLWithPath: bundlePath)
        
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: musicURL)
            backgroundMusicPlayer?.numberOfLoops = -1 
            backgroundMusicPlayer?.prepareToPlay()
            backgroundMusicPlayer?.play()
        } catch {
            print("Couldn't play background music: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
}


class SoundSettings: ObservableObject {
    @Published var isSoundEnabled: Bool = true
}
