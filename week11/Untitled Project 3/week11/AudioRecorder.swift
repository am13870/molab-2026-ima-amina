import Foundation
import SwiftUI
import AVFoundation

// recording samples and keeping them in a list
@Observable
class AudioRecorder: NSObject {

    override init() {
        super.init()
        // load what was saved before
        fetchRecording()
    }

    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false

    // record and save the file as "category_name.m4a"
    func startRecording(name: String, category: String) {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            // letting the app use the mic
            try recordingSession.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try recordingSession.setActive(true)
        } catch {
            print("Failed to set up recording session")
        }

        // if no name was entered then time is used to name the file
        var cleanName = name
        if cleanName == "" {
            cleanName = timeName()
        }

        // folder with app's files
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // file name includes both category and name
        let audioFilename = documentPath.appendingPathComponent("\(category)_\(cleanName).m4a")

        // recording settings
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,        // CD quality - the voice note sample used 12000
            AVNumberOfChannelsKey: 1,      // mono is plenty for a sample
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.record()
            print("audioFilename written", audioFilename)
            recording = true
        } catch {
            print("Could not start recording")
        }
    }

    func stopRecording() {
        audioRecorder.stop()
        recording = false
        // refreshing to see the new sample
        fetchRecording()
    }

    // read the folder and rebuild the list of samples
    func fetchRecording() {
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = (try? fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)) ?? []

        for audio in directoryContents {
            // only sound files
            if audio.pathExtension == "m4a" {
                let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio))
                recordings.append(recording)
            }
        }
        // newest first
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
    }

    // delete by swiping
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted.")
            }
        }
        fetchRecording()
    }
}
