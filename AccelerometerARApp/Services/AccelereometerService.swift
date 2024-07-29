//
//  MotionService.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import Foundation
import CoreMotion
import Combine

protocol AccelerometerServiceProtocol {
    var motionManager: CMMotionManager { get set }
    var timer: Timer? { get set }
    var acceleration: CMAcceleration { get set }
    var isLandscape: Bool { get set }
    func startAccelerometer()
}

final class AccelerometerService: AccelerometerServiceProtocol, ObservableObject {
    var motionManager: CMMotionManager
    var timer: Timer?
    @Published var acceleration: CMAcceleration
    @Published var isLandscape: Bool
    
    init() {
        self.motionManager = CMMotionManager()
        self.acceleration = CMAcceleration(x: 0, y: 0, z: 0)
        self.isLandscape = false
        
        startAccelerometer()
    }
    
    func startAccelerometer() {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0
            motionManager.startAccelerometerUpdates()
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                if let data = self?.motionManager.accelerometerData {
                    DispatchQueue.main.async { [weak self] in
                        self?.acceleration = data.acceleration
                        self?.isLandscape = abs(data.acceleration.x) > abs(data.acceleration.y)
                    }
                }
            }
        } else {
            print("Accelerometer is not available")
        }
    }
    
    deinit {
        self.timer?.invalidate()
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
}
