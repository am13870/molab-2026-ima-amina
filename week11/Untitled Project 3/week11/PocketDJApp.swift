import SwiftUI

@main
struct PocketDJApp: App {
    @State var recorder = AudioRecorder()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(recorder)
        }
    }
}
