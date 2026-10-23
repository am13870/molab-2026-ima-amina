//
//  homework_week05App.swift
//  homework_week05
//
//  Created by Amina Magomedova on 01.10.2026.
//  Edited on 15.10.2026.
//

import SwiftUI

@main
struct homework_week4App: App {
    @State var audioDJ = AudioDJ()
    @State var detector = MotionDetector(updateInterval: 0.1)
    @State var recorder = AudioRecorder()
    @State var notePlayer = AudioPlayer()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioDJ)
                .environment(detector)
                .environment(recorder)
                .environment(notePlayer)
        }
    }
}
