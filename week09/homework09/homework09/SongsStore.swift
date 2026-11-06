//
//  SongsStore.swift
//  homework09
//
//  Created by Amina Magomedova on 05.11.2026.
//

import SwiftUI
import FirebaseFirestore

// colors of the music notes icons
let noteColors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .pink]



// one posted song, codable lets firestore turn a document into this without conversion code
struct SongModel: Identifiable, Codable {
// filled by firestore
  @DocumentID var id: String?
  @ServerTimestamp var createdAt: Date?

  var song: String = ""
  var email: String = ""
  var colorIndex: Int = 0

  // music note changing color
  var color: Color {
    noteColors[colorIndex]
  }
}


// holding the list of songs
@Observable
class SongsStore {

  var items: [SongModel] = []

  @ObservationIgnored
  lazy var store = Firestore.firestore()

  // songs in the database
  @ObservationIgnored
  var collectionRef: CollectionReference {
    store.collection("songs")
  }

  @ObservationIgnored
  var listener: ListenerRegistration? = nil

  static let main = SongsStore()

  // runs every time someone adds or removes song, so the wall is updated
  func loadStoreCollection() {
    if let listener = listener {
      listener.remove()
    }
    listener = collectionRef
      // last added song is on top
      .order(by: "createdAt", descending: true)
      // runs everytime someone adds a song
      .addSnapshotListener { snapShot, error in
        if let error = error {
          print("SongsStore listener error: \(error.localizedDescription)")
          return
        }
          // turn each document into a SongModel
        let nitems = snapShot?.documents.compactMap { document in
          return try? document.data(as: SongModel.self)
        }
          // MainActor moves this to the main thread where screen data changes
        Task { @MainActor in
            // empty list if nothing came back
          self.items = nitems ?? []
        }
      }
  }

  // building a song and sending it to firestore
  func addSong(_ song: String, email: String) {
    let item = SongModel(song: song,
                         email: email,
                         // music note colour
                         colorIndex: Int.random(in: 0..<noteColors.count))
      // if addDocument fails
    do {
      _ = try collectionRef.addDocument(from: item)
    } catch {
      print("SongsStore unable to add song: \(error.localizedDescription)")
    }
  }
}


// truning a date into text, like 2 min ago
func timeAgo(from date: Date?) -> String {
    // empty until firestore fills it in, so check first
  if let date = date {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .short
    return formatter.localizedString(for: date, relativeTo: Date())
  }
  else {
    return ""
  }
}
