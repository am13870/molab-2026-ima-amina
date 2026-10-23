//
//  Develop.swift
//  MyApp
//
//  Created by Amina Magomedova on 23.10.2026.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit
// turning core image results into ordinary pictures
let ciContext = CIContext()
// four looks that can be applied to film
let filmLooks = ["Instant", "Noir", "Vintage", "Chrome"]

// making a smaller copy of the photo (referred to UIGraphicsImageRenderer by Apple Developer Documentation)
func shrink(_ photo: UIImage) -> UIImage {
    let width = 700.0
    // height is based on the width so the photo is not stretched
    let height = width * photo.size.height / photo.size.width
    let size = CGSize(width: width, height: height)
    // drawing the photo in a smaller picture
    let renderer = UIGraphicsImageRenderer(size: size)
    return renderer.image { _ in
        photo.draw(in: CGRect(origin: .zero, size: size))
    }
}
// one photo gets the chosen look + light damage it it is the runied one
func develop(_ photo: UIImage, look: String, burned: Bool) -> UIImage {
    // turn the photo into an image Core Image works with
    let start = CIImage(image: photo)!
    // picture passing from one filter to another
    var working = start
    // ready-made Apple filters (taken from Core Image by Apple Developer Documentation)
    let lookFilter: CIFilter
    if look == "Noir" {
        lookFilter = CIFilter.photoEffectNoir()
    }
    else if look == "Vintage" {
        lookFilter = CIFilter.photoEffectTransfer()
    }
    else if look == "Chrome" {
        lookFilter = CIFilter.photoEffectChrome()
    }
    else {
        lookFilter = CIFilter.photoEffectInstant()
    }
    // set the filter's input picture, then take the result
    lookFilter.setValue(working, forKey: kCIInputImageKey)
    // take the result or the old picture if filter gave nothing
    working = lookFilter.outputImage ?? working
    // runied shot gets three more filters for the burned look
    if burned {
        let exposure = CIFilter.exposureAdjust()
        exposure.inputImage = working
        exposure.ev = 2.0
        working = exposure.outputImage ?? working
        
        let warm = CIFilter.sepiaTone()
        warm.inputImage = working
        warm.intensity = 0.7
        working = warm.outputImage ?? working
        
        let glow = CIFilter.bloom()
        glow.inputImage = working
        glow.intensity = 1.0
        glow.radius = 20
        working = glow.outputImage ?? working
    }
    // turning back into an ordinary picture
    let cgImage = ciContext.createCGImage(working, from: start.extent)!
    return UIImage(cgImage: cgImage)
}
