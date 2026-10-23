//
//  ContentView.swift
//  MyApp
//
//  Created by Amina Magomedova on 23.10.2026.
//

import SwiftUI
// pick four photos, develop them, see which one is ruined
struct ContentView: View {
    // four shots before filters
    @State var photos: [UIImage] = []
    // same four after applying the film look
    @State var developedPhotos: [UIImage] = []
    // new photo is added by picker
    @State var newPhoto: UIImage?
    @State var showingCamera = false
    // which frame the light got to
    @State var burnedIndex = 0
    @State var showingLookSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            Text("Four Shots")
                .font(.system(size: 34, weight: .bold, design: .serif))
                .padding(.top, 10)
            // changing the text depending on how many shots were taken already
            Text(statusText())
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top, 6)
            // empty until the roll is developed
            FilmStrip(photos: developedPhotos)
                .padding(.top, 20)
            // button changes depending on the number of pictures taken
            if photos.count < 4 {
                Button("Take photo \(photos.count + 1) of 4") {
                    showingCamera = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 24)
            }
            else if developedPhotos.isEmpty{
                Button("Develop the roll") {
                    showingLookSheet = true
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 24)
            }
            else {
                HStack(spacing: 16) {
                    Button("New Roll") {
                        newRoll()
                    }
                    .buttonStyle(.bordered)
                    
                    Button("Save photos"){
                        savePhotos()
                    }
                    .buttonStyle(.borderedProminent)
                }
                .controlSize(.large)
                .padding(.top, 24)
            }
        }
        .padding(.horizontal)
        // showing the photo library on the screen
        .sheet(isPresented: $showingCamera) {
            CameraPicker(image: $newPhoto)
        }
        // when the picker writes a photo into new photo
        .onChange(of: newPhoto) {
            if let photo = newPhoto {
                photos.append(shrink(photo))
                // clear for the next photo
                newPhoto = nil
            }
        }
        .confirmationDialog("Choose a film look", isPresented: $showingLookSheet) {
            // one button per look built from develop.swift
            ForEach(filmLooks, id: \.self) { look in
                Button(look) {
                    developRoll(look: look)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
    // line udner the title
    func statusText() -> String {
        if photos.count < 4 {
            return "Shoot 4 photos, then develop."
        }
        if developedPhotos.isEmpty {
            return "The Roll is full, pick its look."
        }
        return "One frame caught the light!"
    }
    // filtering all four photos, picking a random one to ruin
    func developRoll(look: String) {
        burnedIndex = Int.random(in: 0..<4)
        
        var results: [UIImage] = []
        for index in 0..<photos.count {
            // only one frame gets light damage
            let isBurned = (index == burnedIndex)
            results.append(develop(photos[index], look: look, burned: isBurned))
        }
        // photos fade in for the actual film effect
        withAnimation{
            developedPhotos = results
        }
    }
    // empty the lists to start a new roll
    func newRoll() {
        photos = []
        developedPhotos = []
    }
    // to save developed photos on the phone
    func savePhotos() {
        let saver = ImageSaver()
        for photo in developedPhotos {
            saver.writeToPhotoAlbum(image: photo)
        }
    }
        
}

