//
//  AudioPlayer.swift
//  MyApp
//
//  Created by Amina Magomedova on 15.10.2026.
//
import Foundation
import SwiftUI
import Combine
import AVFoundation

// play one voice note once
@Observable
class AudioPlayer: NSObject, AVAudioPlayerDelegate {
    var isPlaying = false
    var audioPlayer: AVAudioPlayer!
    // start playing the file at the given address
    func startPlayback(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        do {
            // sending the sound to loud speaker, not the ear speaker
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("Playing over the device's speakers failed")
        }
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
    // called once the note has finished
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
}
