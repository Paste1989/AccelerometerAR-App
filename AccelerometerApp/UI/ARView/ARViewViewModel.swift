//
//  ARViewViewModel.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 25.07.2024..
//

import Foundation
import SwiftUI

final class ARViewViewModel: ObservableObject {
    var accelerometerService: AccelerometerServiceProtocol
    @Published var distance: Float = 0.0
    @Published var isVerticalSurfaceDetected: Bool = false
    
    init(accelerometerService: AccelerometerServiceProtocol) {
        self.accelerometerService = accelerometerService
    }
    
    let upperDistance: Float = 0.3
    let lowerDistance: Float = 0.2
    
    func isDistanceRangeOk() -> Bool {
        return distance >= lowerDistance && distance <= upperDistance
    }
    
    func isAngleOk() -> Bool {
        return accelerometerService.acceleration.x < 1.0 &&
        accelerometerService.acceleration.x > 0.9 &&
        accelerometerService.acceleration.y < 0.1 &&
        accelerometerService.acceleration.y > -0.04
    }
    
    func handleTopAngleBorder() -> Bool {
        return accelerometerService.acceleration.x > 1.0
    }
    
    func handleBottomAngleBorder() -> Bool {
        return accelerometerService.acceleration.x < 0.9
    }
    
    func handleLeadingAngleBorder() -> Bool {
        return accelerometerService.acceleration.y > 0.1
    }
    
    func hanldeTrailingAngleBorder() -> Bool {
        return accelerometerService.acceleration.y < -0.04
    }
}
