//
//  homework09.swift
//  homework09
//
//  Created by Amina Magomedova on 05.11.2026.
//

import SwiftUI
import FirebaseCore

@main
struct Homework09App: App {

// starting the firebase when the app launches
  init() {
    FirebaseApp.configure()
  }

// shared with every screen
  @State var auth = AuthService.single
  @State var store = SongsStore.main

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(auth)
        .environment(store)
    }
  }
}
