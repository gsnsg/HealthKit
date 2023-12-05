//
//  AccelerometerManager.swift
//  HealthKit_POC
//
//  Created by Sai Nikhit Gulla on 10/8/23.
//

import Foundation
import CoreMotion

/*
 
 This methods reads the accelerometer data and stores to a file patha
*/
class AccelerometerManager {
    private let motionManager = CMMotionManager()
    
    private let operationQueue = OperationQueue()
    
    init() {
        motionManager.accelerometerUpdateInterval = 1.0
    }
    
    func startAccelerometerUpdates(handler: @escaping (CMAccelerometerData?) -> Void) {
        motionManager.startAccelerometerUpdates(to: operationQueue) { (data, error) in
            if let data = data {
                print("X: \(data.acceleration.x), Y: \(data.acceleration.y), Z:\(data.acceleration.z), timestamp: \(data.timestamp)")
            }
        }
    }

    func stopAccelerometerUpdates() {
        motionManager.stopAccelerometerUpdates()
    }
}
