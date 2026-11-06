//
//  SongWallView.swift
//  homework09
//
//  Created by Amina Magomedova on 05.11.2026.
//

import SwiftUI

// the wall: a box to post the song and everyone else's songs below
struct SongWallView: View {
  @Environment(AuthService.self) var auth
  @Environment(SongsStore.self) var store

  @State var song = ""

  var body: some View {
    VStack(spacing: 12) {

      HStack {
        Text("Song Wall")
          .font(.title.bold())
        Spacer()
        Button("Sign out") {
          auth.signOut()
        }
        .font(.caption)
      }

      HStack {
        TextField("Last song you listened to", text: $song)
          .textFieldStyle(.roundedBorder)

        Button("Post") {
          store.addSong(song, email: auth.email)
            // clearing for the enxt song
          song = ""
        }
        .buttonStyle(.borderedProminent)
        .disabled(song == "")
      }

      // the list refills when someone adds a song
      List {
        ForEach(store.items) { item in
          HStack(spacing: 12) {
            Image(systemName: "music.note")
              .font(.title2)
              .foregroundStyle(item.color)

            VStack(alignment: .leading, spacing: 2) {
              Text(item.song)
              Text("\(item.email)   \(timeAgo(from: item.createdAt))")
                .font(.caption)
                .foregroundStyle(.secondary)
            }
          }
        }
      }
      .listStyle(.plain)
    }
    .padding()
    .onAppear {
        // starting to watch the database
      store.loadStoreCollection()
    }
  }
}

#Preview {
  SongWallView()
    .environment(AuthService.single)
    .environment(SongsStore.main)
}
