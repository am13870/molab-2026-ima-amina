import SwiftUI

// every saved sample filtered by category
struct LibraryView: View {
    @Environment(AudioRecorder.self) var recorder

    // which category is showing
    @State var shownCategory = "All"

    // only samples that match the chosen filter
    var shownSamples: [Recording] {
        if shownCategory == "All" {
            return recorder.recordings
        }
        return recorder.recordings.filter { sampleCategory($0.fileURL) == shownCategory }
    }

    var body: some View {
        VStack(spacing: 0) {

            Text("Library")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 10)

            // a row of tabs: "All" and then one icon per category
            Picker("Category", selection: $shownCategory) {
                Text("All").tag("All")
                ForEach(categories, id: \.self) { category in
                    Image(systemName: categoryIcon(category)).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            if shownSamples.isEmpty {
                Spacer()
                Text("No sounds here yet.\nGo out and record some!")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                Spacer()
            }
            else {
                List {
                    // id: \.fileURL tells the list how to tell the rows apart
                    ForEach(shownSamples, id: \.fileURL) { sample in
                        SampleRow(audioURL: sample.fileURL)
                    }
                    // swiping to delete
                    .onDelete(perform: delete)
                }
            }
        }
    }

    // checking which file is at the row and deleting it
    func delete(at offsets: IndexSet) {
        var urlsToDelete = [URL]()
        for index in offsets {
            urlsToDelete.append(shownSamples[index].fileURL)
        }
        recorder.deleteRecording(urlsToDelete: urlsToDelete)
    }
}

// category icon, sample name, play/stop button
struct SampleRow: View {
    var audioURL: URL
    // each row gets its own player
    @State var audioPlayer = AudioPlayer()

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: categoryIcon(sampleCategory(audioURL)))
                .foregroundStyle(.orange)
                .frame(width: 30)

            VStack(alignment: .leading) {
                Text(displayName(audioURL))
                Text(sampleCategory(audioURL))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: {
                if audioPlayer.isPlaying {
                    audioPlayer.stopPlayback()
                }
                else {
                    audioPlayer.startPlayback(audio: audioURL)
                }
            }) {
                Image(systemName: audioPlayer.isPlaying ? "stop.circle.fill" : "play.circle.fill")
                    .font(.system(size: 30))
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    LibraryView()
        .environment(AudioRecorder())
}
