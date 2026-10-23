//
//  FilmStrip.swift
//  MyApp
//
//  Created by Amina Magomedova on 23.10.2026.
//

import SwiftUI

// four frames plus gaps and padding for the strip view
let stripHeight = 460.0
let frameHeight = 104.0
// film strip with sprocket holes on both edges and four frames inside
struct FilmStrip: View {
    // empty until the roll is developed
    var photos: [UIImage]
    var body: some View {
        HStack(spacing: 0) {
            SprocketColumn()
            
            VStack(spacing: 8) {
                // one frame per shot
                ForEach(0..<4, id: \.self) { index in
                    FilmFrame(
                        // handing a photo when there is one for this slot
                        photo: index < photos.count ? photos[index] : nil,
                        index: index
                    )
                }
            }
            .padding(.vertical, 10)
            
            SprocketColumn()
        }
        .frame(height: stripHeight)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
// one column of sprocket holes
struct SprocketColumn: View {
    var body: some View{
        VStack(spacing: 12) {
            ForEach(0..<20, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 2)
                    .fill(.white)
                    .frame(width: 9, height: 13)
            }
        }
        // fill the strip from the top and cut off extra holes on the bottom
        .frame(maxHeight: .infinity, alignment: .top)
        .clipped()
        .padding(.horizontal, 7)
    }
}
// one frame with an empty slot and photo fading on top
struct FilmFrame: View {
    var photo: UIImage?
    var index: Int
    var body: some View {
        ZStack {
            // empty slot
            Rectangle()
                .fill(Color.gray.opacity(0.2))
            // when there is a photo for the slot
            if let photo = photo {
                Image(uiImage: photo)
                    .resizable()
                    .scaledToFill()
                // setting up how the photo appears - one after another with the delay
                    .transition(.opacity.animation(.easeIn(duration:1.5).delay(Double(index) * 0.7)))
            }
        }
        .frame(height: frameHeight)
        // keeping a wide photo inside its frame
        .clipped()
    }
}

#Preview {
    FilmStrip(photos: [])
        .padding()
}
