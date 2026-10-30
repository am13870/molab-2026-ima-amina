//
//  FaceViewAR.swift
//  homework09
//
//  Created by Amina Magomedova on 29.10.2026.
//

import ARKit
import SceneKit
import SwiftUI

// draws the face mesh and sends blend shapes to face tracker
struct FaceViewAR: UIViewRepresentable {
    let tracker: FaceTracker

    func makeCoordinator() -> Coordinator {
        Coordinator(tracker: tracker)
    }
    // building the AR screen the first time it is shown
    func makeUIView(context: Context) -> ARSCNView {
        let view = ARSCNView(frame: .zero)
        view.delegate = context.coordinator
        view.session.delegate = context.coordinator
        view.automaticallyUpdatesLighting = true

        if ARFaceTrackingConfiguration.isSupported {
            let config = ARFaceTrackingConfiguration()
            config.maximumNumberOfTrackedFaces = 1
            config.isLightEstimationEnabled = true
            view.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        }
        return view
    }
    // called when content view redraws, changing the forehead photo
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        // take what the tracker is showing now, run the function again when they change
        let emotion = tracker.emotion
        let imageName = tracker.currentImageName
        // find the photo rectangle named when face appeared
        let photoNode = uiView.scene.rootNode.childNode(withName: "photo", recursively: true)
        // nothing is shown when the face is neutral
        photoNode?.isHidden = (emotion == "none")
        // put the current picture on it
        photoNode?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: imageName)
    }

    static func dismantleUIView(_ uiView: ARSCNView, coordinator: Coordinator) {
        uiView.session.pause()
    }

    final class Coordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
        let tracker: FaceTracker

        init(tracker: FaceTracker) {
            self.tracker = tracker
        }

        nonisolated func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard anchor is ARFaceAnchor,
                  let device = renderer.device,
                  let faceGeometry = ARSCNFaceGeometry(device: device) else { return nil }
            let material = faceGeometry.firstMaterial
            material?.fillMode = .lines
            material?.diffuse.contents = UIColor.cyan
            material?.lightingModel = .constant
            let faceNode = SCNNode(geometry: faceGeometry)
            // flat rectangle for the photo (measurements adjusted to fit the 3:4 dimensions)
            let plane = SCNPlane(width: 0.07, height: 0.0525)

            let photoNode = SCNNode(geometry: plane)
            // updateUIView can find it again
            photoNode.name = "photo"
            // nothing is shown yet
            photoNode.isHidden = true
            // adjusting the position of the photo
            photoNode.position = SCNVector3(0, 0.08, 0.055)
            // added as a child, so it moves with the face
            faceNode.addChildNode(photoNode)

            return faceNode
        }
        // called every frame when the face is visible
        nonisolated func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            guard let faceAnchor = anchor as? ARFaceAnchor else { return }
            // the wireframe is reshaped to match the moving face
            (node.geometry as? ARSCNFaceGeometry)?.update(from: faceAnchor.geometry)

            let blendShapes = faceAnchor.blendShapes
            let tracked = faceAnchor.isTracked
            Task { @MainActor [tracker] in
                if tracked {
                    tracker.update(blendShapes: blendShapes)
                } else {
                    tracker.faceLost()
                }
            }
        }
        // when face goes out of view
        nonisolated func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
            guard anchor is ARFaceAnchor else { return }
            Task { @MainActor [tracker] in tracker.faceLost() }
        }
        // when something interrupts the camera
        nonisolated func sessionWasInterrupted(_ session: ARSession) {
            Task { @MainActor [tracker] in tracker.faceLost() }
        }
    }
}
