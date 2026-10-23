//
//  AudioRecorder.swift
//  MyApp
//
//  Created by Amina Magomedova on 15.10.2026.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

// record voice note and keep a lsit of saved ones
@Observable
class AudioRecorder: NSObject {
    
    override init() {
        super.init()
        // loading what was saved last time
        fetchRecording()
    }
    
    var audioRecorder: AVAudioRecorder!
    var recordings = [Recording]()
    var recording = false
    // note chosen from the sleep timer page
    var selectedNote = ""
    // starting to record and saving the file under person's na,e
    func startRecording(name: String) {
        let recordingSession = AVAudioSession.sharedInstance()
        do {
            // to let the app use the microphone
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        } catch {
            print("Failed to record")
        }
       
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]

        let audioFilename = documentPath.appendingPathComponent("\(name).m4a")
        
        // how the sound is recorded
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
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
        // refreshing the list so the new note appears
        fetchRecording()
    }
    // reading the folder and rebuilding the list of saved notes
    func fetchRecording() {
        recordings.removeAll()
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryContents = try! fileManager.contentsOfDirectory(at: documentDirectory, includingPropertiesForKeys: nil)
        
        for audio in directoryContents {
            let recording = Recording(fileURL: audio, createdAt: getFileDate(for: audio))
            recordings.append(recording)
        }
        // newest notes go first
        recordings.sort(by: { $0.createdAt.compare($1.createdAt) == .orderedDescending })
    }
    // deleting the swiped files
    func deleteRecording(urlsToDelete: [URL]) {
        for url in urlsToDelete {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                print("File could not be deleted!")
            }
        }
        fetchRecording()
    }
}
