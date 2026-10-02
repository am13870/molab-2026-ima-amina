//
//  homework_week04App.swift
//  homework_week04
//
//  Created by Amina Magomedova on 01.10.2026.
//

import SwiftUI

@main
struct homework_week4App: App {
    @State var audioDJ = AudioDJ()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(audioDJ)
        }
    }
}
