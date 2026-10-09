//
//  ContentView.swift
//  homework_week05
//
//  Created by Amina Magomedova on 01.10.2026.
//  Edited on 08.10.2026.
//

import SwiftUI
// home screen
struct ContentView: View {
    // shared audioDJ between pages
    @Environment(AudioDJ.self) var audioDJ
    
    var body: some View {
        NavigationView {
            // I used padding for gaps, although this is not responsive, to set up specific layout that I wanted
            VStack(spacing: 0) {
                
                Text("Music to Sleep")
                    .font(.system(size: 40, weight: .bold))
                    .padding(.top, 20)
                
                // the icon changes when the sound starts or stops
                Image(systemName: audioDJ.isPlaying ? "waveform" : "speaker.slash")
                    .font(.system(size: 90))
                    .foregroundStyle(.teal)
                    .padding(.top, 170)
                
                // changing the text depending on the audio
                Text(audioDJ.isPlaying ? "Playing \(audioDJ.soundName)" : "Looks like you are sleeping...")
                    .foregroundStyle(.secondary)
                    .padding(.top, 16)
                // button to the library page
                NavigationLink(destination: MusicLibrary()) {
                    Label("Your Library", systemImage: "music.note.list")
                        .frame(maxWidth: 140)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 150)
                // button to the timer
                NavigationLink(destination: SleepTimer()) {
                    Label("Sleep Timer", systemImage: "moon.zzz")
                        .frame(maxWidth: 140)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.top, 12)
                // button to the sleep monitor
                NavigationLink(destination: SleepMonitor()) {
                    Label("Sleep Monitor", systemImage: "waveform.path.ecg")
                        .frame(maxWidth: 140)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.top, 12)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
        .environment(AudioDJ())
}
