//
//  CameraPicker.swift
//  MyApp
//
//  Created by Amina Magomedova on 23.10.2026.
//

import SwiftUI
import UIKit
// opening the photo library and picking a picture
struct CameraPicker: UIViewControllerRepresentable {
    // writing into the value in content view page
    @Binding var image: UIImage?
    // photo library calls one of the functions below when the photo is chosen
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        // so the chosen photo can be writtten into parent.image
        var parent: CameraPicker
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        // photo library calls this once a picture was chosen
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // info holds several things about the choice, asking for the picture
            let chosen = info[.originalImage]
            // using only if it is a picture
            if let photo = chosen as? UIImage {
                // handing it back to content view
                parent.image = photo
            }
            // closing the library screen
            picker.dismiss(animated: true)
        }
        // building the library screen the first time
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
    // building the library screen the first time
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
