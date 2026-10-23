//
//  SleepTimer.swift
//  homework_week05
//
//  Created by Amina Magomedova on 01.10.2026.
//  Edited on 15.10.2026.
//

import SwiftUI
import Combine

// counts down and pauses music
struct SleepTimer: View {
    // shared audioDJ
    @Environment(AudioDJ.self) var audioDJ
    // shared recorder that holds notes and the chosen note
    @Environment(AudioRecorder.self) var recorder
    // player used for the note
    @Environment(AudioPlayer.self) var notePlayer
    // how long until the souns stops
    @State var secondsLeft = 0
    // checking if the countdown is running
    @State var isCounting = false
    // timer is updated every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        // to let the picker write into recorder.selectedNote
        @Bindable var recorder = recorder
        
        VStack() {
            
            Text("Sleep Timer")
                .font(Font.system(size: 30, weight: .bold))
                .padding(.top, 0)
            // seconds into text
            Text(timeText(secondsLeft))
                .font(Font.system(size: 70, design: .monospaced))
                .padding(.top, 130)
            // changing the text depending on the audio
            Text(audioDJ.isPlaying ? "Playing \(audioDJ.soundName)" : "It is quiet now...")
                .foregroundStyle(.secondary)
                .padding(.top, 16)
            
            HStack(spacing: 20) {
                Button("- 30s") {
                    // time is deducted
                    addTime(-30)
                }
                .buttonStyle(.bordered)
                
                Button("+ 30s") {
                    // time is added
                    addTime(30)
                }
                .buttonStyle(.bordered)
            }
            .padding(.top, 40)
            // label changes with the state of countdown
            Button(isCounting ? "Stop" : "Start") {
                startStopAction()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top, 24)
            
            // dropdown of recorded notes with tags
            Picker("Good night note", selection : $recorder.selectedNote) {
                Text("None").tag("")
                ForEach(recorder.recordings, id: \.createdAt) { recording in Text(noteName(recording.fileURL)).tag(noteName(recording.fileURL))
                }
            }
            .pickerStyle(.menu)
            .padding(.top, 30)
            
            Text("This note plays once after the music stops.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
        .onReceive(timer) { _ in
            // update each second
            if isCounting && secondsLeft > 0 {
                secondsLeft -= 1
                // stop the music if countdown is over
                if secondsLeft == 0 {
                    isCounting = false
                    audioDJ.stop()
                    playGoodNightNote()
                }
            }
        }
    }
    
    // plays the chosen note
        func playGoodNightNote() {
            // if there is nothing to play
            if recorder.selectedNote == "" {
                return
            }
            // find the note with a matching name
            for recording in recorder.recordings {
                if noteName(recording.fileURL) == recorder.selectedNote {
                    notePlayer.startPlayback(audio: recording.fileURL)
                }
            }
        }
    
    // adds or removes time from the clock
    func addTime(_ seconds: Int) {
        secondsLeft += seconds
        if secondsLeft < 0 {
            // so time does not go negative
            secondsLeft = 0
        }
    }
    // stop or start the countdown
    func startStopAction() {
        if isCounting {
            isCounting = false
        }
        // start only if there is time left
        else if secondsLeft > 0 {
            isCounting = true
        }
    }
}

#Preview {
    SleepTimer()
        .environment(AudioDJ())
        .environment(AudioRecorder())
        .environment(AudioPlayer())
}
