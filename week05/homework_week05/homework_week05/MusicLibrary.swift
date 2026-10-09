//
//  MusicLibrary.swift
//  homework_week05
//
//  Created by Amina Magomedova on 01.10.2026.
//  Edited on 08.10.2026.
//

import SwiftUI
import Combine
// player page
struct MusicLibrary: View {
    // shared audioDJ
    @Environment(AudioDJ.self) var audioDJ
    // seconds counted since play was pressed
    @State var elapsed = 0
    
    //timer is updated every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        // for toggle to change isLooping
        @Bindable var audioDJ = audioDJ
        
        VStack() {
            
            Text("Your Library")
                .font(Font.system(size: 30, weight: .bold))
                .padding(.top, 0)
            
            // album cover for each song
            Image(audioDJ.soundCover)
                .resizable()
            // resizable but proportions are kept
                .aspectRatio(contentMode: .fit)
                .frame(width: 260, height: 260)
            // rounded corners
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 8)
                .padding(.top, 80)
            
            Text(audioDJ.soundName)
                .font(.title2)
                .padding(.top, 25)
            // turning counted seconds into text
            Text(timeText(elapsed))
                .font(Font.system(size: 44, design: .monospaced))
                .foregroundStyle(.secondary)
                .padding(.top, 8)
            // three player buttons in a row
            HStack(spacing: 50) {
                Button(action: previousAction) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .frame(width: 40, height: 34)
                }
                Button(action: playPauseAction) {
                    // changing play-pause icons
                    Image(systemName: audioDJ.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .frame(width: 34, height: 40)
                }
                Button(action: nextAction) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .frame(width: 40, height: 34)
                }
            }
            .padding(.top, 30)
            // switch writes into audioDJ.isLooping to update
            Toggle("Loop", isOn: $audioDJ.isLooping)
                .padding(.horizontal, 40)
                .padding(.top, 30)
        }
        .padding(.horizontal)
        .onReceive(timer) { _ in
            // runs once a second
            if audioDJ.isPlaying {
                elapsed += 1
            }
        }
    }
    // stop the song if it is playing
    func playPauseAction() {
        if audioDJ.isPlaying {
            audioDJ.stop()
        }
        // or play if it is not
        else {
            elapsed = 0
            audioDJ.play()
        }
    }
    // switching between songs
    func previousAction() {
        elapsed = 0
        audioDJ.previous()
    }
    
    func nextAction() {
        elapsed = 0
        audioDJ.next()
    }
}

#Preview {
    MusicLibrary()
        .environment(AudioDJ())
}
