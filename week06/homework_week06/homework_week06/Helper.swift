//
//  Helper.swift
//  MyApp
//
//  Created by Amina Magomedova on 15.10.2026.
//

import Foundation

func getFileDate(for file: URL) -> Date{
    if let attributes = try? FileManager.default.attributesOfItem(atPath: file.path) as [FileAttributeKey: Any],
       let creationDate = attributes[FileAttributeKey.creationDate] as? Date {
        
        return creationDate
    }
    else {
        return Date()
    }
}

func noteName(_ url: URL) -> String {
    return url.deletingPathExtension().lastPathComponent
}
