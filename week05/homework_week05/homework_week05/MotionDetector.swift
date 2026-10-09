//
//  MotionDetector.swift
//  homework_week05
//
//  Created by Amina Magomedova on 08.10.2026.
//

import CoreMotion

// reading the phone's motion sensors and share the numbers
@Observable
class MotionDetector {
    private let motionManager = CMMotionManager()
    
    private var timer = Timer()
    private var updateInterval: TimeInterval
    
    // only up and down movement
    var zAcceleration: Double = 0
    // movements in all directions added
    var movement: Double = 0
    
    var onUpdate: (() -> Void) = {}
    
    init(updateInterval: TimeInterval) {
        self.updateInterval = updateInterval
    }
    // switching the sensors on and start reading
    func start() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.startDeviceMotionUpdates()
            // taking a reading every updateInterval at 10 per second
            timer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { _ in self.updateMotionData() }
        }
        else {
            // if motion could not be tracked
            print("Could not track motion data on this device...")
        }
    }
    // taking one reading from the sensors
    func updateMotionData() {
        // when there is actually a reading
        if let data = motionManager.deviceMotion {
            zAcceleration = data.userAcceleration.z
            // added abs to remove the minus sign, so movement in opposite direction adds up
            movement = abs(data.userAcceleration.x) + abs(data.userAcceleration.y) + abs(data.userAcceleration.z)
            
            onUpdate()
        }
    }
    // switch the sensors off
    func stop() {
        motionManager.stopDeviceMotionUpdates()
        timer.invalidate()
    }
    
    deinit {
        stop()
    }
}

extension MotionDetector {
    func started() -> MotionDetector {
        start()
        return self
    }
}
