//
//  SleepMonitor.swift
//  homework_week05
//
//  Created by Amina Magomedova on 08.10.2026.
//

import SwiftUI
import Combine

// watching the phone's motion: stop the music when it is still, shuffle songs when it is shaken
struct SleepMonitor: View {
    // shared auidioDJ so the page can stop music that was started at the library
    @Environment(AudioDJ.self) var audioDJ
    // shared motion detector keeps taking sensor readings
    @Environment(MotionDetector.self) var detector
    
    // how long the phone was still
    @State var stillSeconds = 0
    // did it move in the last second
    @State var movedRecently = false
    // prevents one shake being counted many times
    @State var shakeCooldown = 0
    // seconds of stillness before stopping the music
    @State var sleepAfter = 15.0
    
    // how much movement counts as moving and as shaking
    let moveLimit = 0.05
    let shakeLimit = 1.5
    
    // timer is updated every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack() {
            
            Text("Sleep Monitor")
                .font(Font.system(size: 30, weight: .bold))
                .padding(.top, 0)
            
            // the icon changes once the phone is still
            Image(systemName: stillSeconds > 0 ? "moon.zzz.fill" : "iphone.gen3")
                .font(.system(size: 70))
                .foregroundStyle(.teal)
                .padding(.top, 50)
            
            // added after testing - it was unclear whether the shuffle was successful after shaking
            Text(audioDJ.soundName)
                .font(.title2)
                .padding(.top, 20)
            // shaking changes the song even when paused, so both are shown
            Text(audioDJ.isPlaying ? "Playing" : "Paused")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Text("Still for \(stillSeconds)s")
                .font(.title2)
                .padding(.top, 25)
            
            // the bar fills up as the stillness count increases
            ProgressView(value: Double(stillSeconds), total: sleepAfter)
                .padding(.horizontal, 60)
                .padding(.top, 10)
            
            // live sensor reading shown so the thresholds above can be tuned
            
            // multiplying by 100 to turn small readings into whole numbers
            Text("Movement \(Int(detector.movement * 100))")
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.top, 20)
            
            // added int to cut off decimals
            Text("Stop the music after \(Int(sleepAfter))s")
                .font(.headline)
                .padding(.top, 40)
            // $ lets the slider write straight into sleepAfter
            Slider(value: $sleepAfter, in: 5...60, minimumValueLabel: Text("5"), maximumValueLabel: Text("60")) {
                
                Text("Stop After")
            }
            .padding(.horizontal, 40)
            
            Text("Leave the phone still and the music stops on its own. Shake it to shuffle.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
                .padding(.top, 30)
        }
        .padding(.horizontal)
        .onAppear {
            detector.start()
            
            // runs after every sensor reading 10 times a second, flips movedRecently to true
            detector.onUpdate = {
                if detector.movement > moveLimit {
                    movedRecently = true
                }
                checkForShake()
            }
        }
        // switching the sensor off when not on the sleep monitor page
        .onDisappear {
            detector.stop()
        }
        .onReceive(timer) { _ in
            countStillness()
        }
    }
    // runs once a second, counts stillness and stops the music at the limit
    func countStillness() {
        // checkiing movedRecentlyflag, clear it for the next second
        if movedRecently {
            stillSeconds = 0
            movedRecently = false
        }
        else {
            stillSeconds += 1
        }
        
        // first iteration - two conditions combined. during testing i noticed that the counter could go past the limit and the progress bar had nowhere left to fill. when no music was playing, the && was false, so nothing reset.
        
        //OLD statement: if stillSeconds >= Int(sleepAfter) && audioDJ.isPlaying {
        
        // NEW version - the counter resets at the limit, music stops only if it was playing.
        if stillSeconds >= Int(sleepAfter) {
            if audioDJ.isPlaying {
                audioDJ.stop()
            }
            stillSeconds = 0
        }
    }
    // runs after every reading, shaking the phone changes the song
    func checkForShake() {
        // one shake lasts several readings, so one is tracked and the next 20 are counted down and ignored to avoid constant shuffling
        if shakeCooldown > 0 {
            shakeCooldown -= 1
        }
        // big shake moves to the next song and starts the cooldown
        else if detector.movement > shakeLimit {
            audioDJ.next()
            shakeCooldown = 20
        }
    }
}

#Preview {
    SleepMonitor()
        .environment(AudioDJ())
        .environment(MotionDetector(updateInterval: 0.1).started())
}
