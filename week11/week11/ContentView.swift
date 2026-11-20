import SwiftUI

// home screen
struct ContentView: View {

    @Environment(AudioRecorder.self) var recorder

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                Text("Pocket DJ")
                    .font(.system(size: 48, weight: .heavy))
                    .padding(.top, 60)

                // updates whenever a sample is added or deleted
                Text("\(recorder.recordings.count) city sounds collected")
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)

                Image(systemName: "waveform")
                    .font(.system(size: 90))
                    .foregroundStyle(.orange)
                    .padding(.top, 80)

                Spacer()

                NavigationLink(destination: RecordView()) {
                    Label("Record", systemImage: "mic.fill")
                        .frame(maxWidth: 90)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                .controlSize(.large)

                NavigationLink(destination: LibraryView()) {
                    Label("Library", systemImage: "square.stack.fill")
                        .frame(maxWidth: 90)
                }
                .buttonStyle(.bordered)
                .controlSize(.large)
                .padding(.top, 12)

                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    ContentView()
        .environment(AudioRecorder())
}
