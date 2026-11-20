import Foundation
import SwiftUI
import AVFoundation

// plays the sample once and stops
@Observable
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var isPlaying = false
    var audioPlayer: AVAudioPlayer!

    // starts playing the file
    func startPlayback(audio: URL) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audio)
                audioPlayer.delegate = self
                audioPlayer.play()
                isPlaying = true
            } catch {
                print("Playback failed.")
            }
        }

    func stopPlayback() {
        audioPlayer.stop()
        isPlaying = false
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
