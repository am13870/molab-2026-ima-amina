//
//  FaceTracker.swift
//  homework09
//
//  Created by Amina Magomedova on 29.10.2026.
//
import ARKit
import Observation
// holds what ARkit sees on the face and links it to an emotion
@Observable
final class FaceTracker {
    var isSupported = ARFaceTrackingConfiguration.isSupported
    var faceDetected = false
    // three simple expressions i chose - happy, sad, surprised
    var smile: Float = 0
    var frown: Float = 0
    var browUp: Float = 0
    // how strong an expression has to be before it counts
    var threshold: Float = 0.3
    // current emotion
    var emotion = "none"
    // which of three photos for that emotion is on the forehead
    var photoIndex = 0

    // emotion that was seen and for how may frames
    private var candidate = "none"
    private var heldFrames = 0
    // to avoid flickering between emotions it has to stay for 10 frames to switched to
    let framesNeeded = 10
    // line at the botton of the screen saying which emotion was detected
    var status: String {
        guard isSupported else { return "Face tracking not supported on this device" }
        guard faceDetected else { return "No face detected" }
        if emotion == "none" { return "Neutral" }
        return "You look \(emotion)!"
    }
    // building the asset name from emotion and photo number
    var currentImageName: String {
        return "\(emotion)\(photoIndex + 1)"
    }
    // called by AR view every frame
    func update(blendShapes: [ARFaceAnchor.BlendShapeLocation: NSNumber]) {
        // mouth is measured separately on both sides
        // happy
        let smileL = blendShapes[.mouthSmileLeft]?.floatValue ?? 0
        let smileR = blendShapes[.mouthSmileRight]?.floatValue ?? 0
        smile = (smileL + smileR) / 2
        // sad
        let frownL = blendShapes[.mouthFrownLeft]?.floatValue ?? 0
        let frownR = blendShapes[.mouthFrownRight]?.floatValue ?? 0
        frown = (frownL + frownR) / 2
        // surprised
        browUp = blendShapes[.browInnerUp]?.floatValue ?? 0

        faceDetected = true
        decideEmotion()
    }
    // deciding which emotion is shown and changing after it is held for 10 frames
    func decideEmotion() {
        var guess = "none"
        if smile > threshold {
            guess = "happy"
        }
        else if frown > threshold {
            guess = "sad"
        }
        else if browUp > threshold {
            guess = "surprised"
        }
        // if the guess is the same as last frame it is counted
        if guess == candidate {
            heldFrames += 1
        }
        // if it is different then the coutn restarts
        else {
            candidate = guess
            heldFrames = 1
        }
        // when the emotion is held long enough and it is different from the curretnly displayed emotion
        if heldFrames >= framesNeeded && guess != emotion {
            emotion = guess
            // new slideshow starts from the first photo
            photoIndex = 0
        }
    }
    // two arrow buttons, slideshow looped
    func nextPhoto() {
        photoIndex = (photoIndex + 1) % 3
    }

    func previousPhoto() {
        photoIndex = (photoIndex - 1 + 3) % 3
    }
    // if the face is out of view everything resets
    func faceLost() {
        faceDetected = false
        smile = 0
        frown = 0
        browUp = 0
        emotion = "none"
        candidate = "none"
        heldFrames = 0
    }
}
