//
//  ContentView.swift
//  homework09
//
//  Created by Amina Magomedova on 29.10.2026.
//

import SwiftUI
// tracker shared with the AR view
struct ContentView: View {
    @State private var tracker = FaceTracker()

    var body: some View {
        // camera view fills the screen, text and buttons are in the bottom (similar to the FaceMeshUI layout)
        ZStack(alignment: .bottom) {
            if tracker.isSupported {
                FaceViewAR(tracker: tracker)
                    .ignoresSafeArea()
            } else {
                // for devices with no face tracking
                Color.black.ignoresSafeArea()
            }

            VStack(spacing: 10) {
                // which emotion was detected
                Text(tracker.status)
                    .font(.title2.bold())
                // arrows appear after an emotion was detected
                if tracker.emotion != "none" {
                    // switching between three photos
                    Text("Photo \(tracker.photoIndex + 1) of 3")
                        .font(.caption.monospacedDigit())

                    HStack(spacing: 50) {
                        // arrow button 1
                        Button {
                            tracker.previousPhoto()
                        } label: {
                            Image(systemName: "chevron.left.circle.fill")
                                .font(.system(size: 44))
                        }
                        // arrow button 2
                        Button {
                            tracker.nextPhoto()
                        } label: {
                            Image(systemName: "chevron.right.circle.fill")
                                .font(.system(size: 44))
                        }
                    }
                }
            }
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            // dark box for the text
            .background(.black.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
