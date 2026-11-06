//
//  ContentView.swift
//  homework09
//
//  Created by Amina Magomedova on 05.11.2026.
//
import SwiftUI

// shows the sign in form or the song wall, whether user is signed in
struct ContentView: View {
    // shared AuthService
  @Environment(AuthService.self) var auth

  var body: some View {
    VStack {
      if auth.signedIn {
        SongWallView()
      }
      else {
        SignInView()
      }
    }
    .onAppear {
        // starting the sign in listener
      auth.start()
    }
  }
}


// the form: email, password, two things you can do with them
struct SignInView: View {
  @Environment(AuthService.self) var auth

  @State var email = ""
  @State var password = ""

  var body: some View {
    VStack(spacing: 16) {

      Image(systemName: "music.note")
        .font(.system(size: 60))
        .foregroundStyle(.purple)

      Text("Song Wall")
        .font(.largeTitle.bold())

      Text("Sign in to share the last song you listened to")
        .font(.caption)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)

      TextField("Email", text: $email)
        .textFieldStyle(.roundedBorder)
        // emails don't have capitals
        .textInputAutocapitalization(.never)
        
    // hiding what is typed, taken from https://developer.apple.com/documentation/swiftui/securefield
      SecureField("Password", text: $password)
        .textFieldStyle(.roundedBorder)

      HStack(spacing: 16) {
        Button("Sign up") {
          auth.signUp(email: email, password: password)
        }
        .buttonStyle(.bordered)
          // sing into the existing account
        Button("Sign in") {
          auth.signIn(email: email, password: password)
        }
        .buttonStyle(.borderedProminent)
      }
      .controlSize(.large)
        // if firebase rejects the email or password
      if auth.errorMessage != "" {
        Text(auth.errorMessage)
          .font(.caption)
          .foregroundStyle(.red)
          .multilineTextAlignment(.center)
      }
    }
    .padding(40)
  }
}

#Preview {
  ContentView()
    .environment(AuthService.single)
    .environment(SongsStore.main)
}
