//
//  AudioDJ.swift
//  homework_week04
//
//  Created by Amina Magomedova on 01.10.2026.
//

import AVFoundation

// holds the sound that is playing
@Observable
class AudioDJ {
    // which song from the list
    var soundIndex = 0
    var soundFile = AudioDJ.audioRef[0]
    var soundName = AudioDJ.audioNames[0]
    var soundCover = AudioDJ.audioCovers[0]
    // shared between both pages
    var isPlaying = false
    // set by the switch on the library page
    var isLooping = true
    var player: AVAudioPlayer? = nil
    
    init() {
    }
    
    // loading the chosen file and playing
    func play() {
        player = loadAudio(soundFile)
        // -1 to loop constantly
        player?.numberOfLoops = isLooping ? -1 : 0
        player?.play()
        isPlaying = true
    }
    
    func stop() {
        player?.stop()
        isPlaying = false
    }
    
    func next() {
        choose(soundIndex + 1)
    }
    
    func previous() {
        // adding the count so the number never drops below zero
        choose(soundIndex - 1 + AudioDJ.audioRef.count)
    }
    
    // picking a song by number and updating what the screen shows
    func choose(_ index: Int) {
        // mod to wrap back to the first song
        soundIndex = index % AudioDJ.audioRef.count
        soundFile = AudioDJ.audioRef[soundIndex]
        soundName = AudioDJ.audioNames[soundIndex]
        soundCover = AudioDJ.audioCovers[soundIndex]
        if isPlaying {
            play()
        }
    }
    // finding an mp3 file and get it ready to play
    func loadAudio(_ fileName: String) -> AVAudioPlayer? {
        let path = Bundle.main.path(forResource: fileName, ofType: nil)!
        let url = URL(fileURLWithPath: path)
        // skip a song if file is not loaded instead of crashing
        return try? AVAudioPlayer(contentsOf: url)
    }
    
    // titles shown on screen
    static let audioNames = ["Movement 3", "sovietmorningforest", "Radio Shaolin"]
    
    // mp3 files imported
    static let audioRef = ["Song1.mp3", "Song2.mp3", "Song3.mp3"]
    
    // cover images in assets
    static let audioCovers = ["Cover1", "Cover2", "Cover3"]
}
// turning number of seconds into text
func timeText(_ seconds: Int) -> String {
    // whole minutes
    let minutes = seconds/60
    // seconds left over
    let rest = seconds%60
    // adding the minutes
    var text = "\(minutes):"
    // to add 0 before single seconds
    if rest < 10 {
        text += "0"
    }
    // adding the seconds
    text += "\(rest)"
    return text
}
