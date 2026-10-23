//
//  NoteLibrary.swift
//  MyApp
//
//  Created by Amina Magomedova on 15.10.2026.
//

import SwiftUI

// recording page
struct NoteLibrary: View {
    // shared recorder
    @Environment(AudioRecorder.self) var recorder
    
    // name is typed before recording starts
    @State var personName = ""
    
    var body: some View {
        VStack() {
            
            Text("Good Night Notes")
                .font(Font.system(size: 30, weight: .bold))
                .padding(.top, 10)
            
            // saved notes
            NotesList(recorder: recorder)
            
            TextField("Whose note is this?", text: $personName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 50)
            
            // changing buttons
            if recorder.recording == false {
                Button(action: {
                    recorder.startRecording(name: personName)
                }) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.red)
                }
                // grey until a name is typed
                .disabled(personName == "")
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
            else {
                Button(action: {
                    recorder.stopRecording()
                    // clearing the field for the next name
                    personName = ""
                }) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(.red)
                }
                .padding(.top, 20)
                .padding(.bottom, 30)
            }
        }
    }
}

// the list of saved notes
struct NotesList: View {
    var recorder: AudioRecorder
    
    var body: some View {
        List {
            ForEach(recorder.recordings, id: \.createdAt) { recording in
                NoteRow(audioURL: recording.fileURL)
            }
            // swiping to delete
            .onDelete(perform: delete)
        }
    }
    
    // deleting the swiped row
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(recorder.recordings[index].fileURL)
        }
        recorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

// person's name and play button
struct NoteRow: View {
    var audioURL: URL
    // a player for each row
    var audioPlayer = AudioPlayer()
    
    var body: some View {
        HStack {
            Text(noteName(audioURL))
            // using spacer for responsiveness
            Spacer()
            if audioPlayer.isPlaying == false {
                Button(action: {
                    audioPlayer.startPlayback(audio: audioURL)
                }) {
                    Image(systemName: "play.circle")
                        .imageScale(.large)
                }
            }
            else {
                Button(action: {
                    audioPlayer.stopPlayback()
                }) {
                    Image(systemName: "stop.fill")
                        .imageScale(.large)
                }
            }
        }
    }
}

#Preview {
    NoteLibrary()
        .environment(AudioRecorder())
}
