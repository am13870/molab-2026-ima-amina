import SwiftUI
import Combine

// recording page
struct RecordView: View {
    // the shared recorder
    @Environment(AudioRecorder.self) var recorder

    // the name typed in
    @State var typedName = ""
    // the category button
    @State var chosenCategory = "Traffic"
    // how long the current recording is
    @State var seconds = 0
    // ticks once a second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {

            Text("Record")
                .font(.system(size: 30, weight: .bold))
                .padding(.top, 10)

            // four category buttons
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        chosenCategory = category
                    }) {
                        VStack(spacing: 6) {
                            Image(systemName: categoryIcon(category))
                                .font(.system(size: 26))
                            Text(category)
                                .font(.caption)
                        }
                        .frame(width: 76, height: 76)
                        .background(chosenCategory == category ? Color.orange : Color.gray.opacity(0.15))
                        .foregroundStyle(chosenCategory == category ? Color.white : Color.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    // category cannot be changed during recording
                    .disabled(recorder.recording)
                }
            }
            .padding(.top, 30)

            TextField("Name it (optional)", text: $typedName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 40)
                .padding(.top, 30)

            Spacer()

            // length of the recording
            Text(timeText(seconds))
                .font(.system(size: 50, design: .monospaced))
                .foregroundStyle(recorder.recording ? Color.red : Color.secondary)

            // switching between record and stop
            Button(action: recordStopAction) {
                Image(systemName: recorder.recording ? "stop.circle.fill" : "record.circle.fill")
                    .font(.system(size: 120))
                    .foregroundStyle(.red)
            }
            .padding(.top, 20)
            .padding(.bottom, 50)
        }
        .onReceive(timer) { _ in
            if recorder.recording {
                seconds += 1
            }
        }
    }

    // start or stop
    func recordStopAction() {
        if recorder.recording {
            recorder.stopRecording()
            // clear for the next sound
            typedName = ""
        }
        else {
            seconds = 0
            recorder.startRecording(name: typedName, category: chosenCategory)
        }
    }
}

#Preview {
    RecordView()
        .environment(AudioRecorder())
}
