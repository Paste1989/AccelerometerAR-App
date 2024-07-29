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

    let topAngle: Double = 0.0
    let bottomAngle: Double = -0.35
    let leadingAngle: Double = -0.05
    let trailingAngle: Double = 0.03
    
    func isDistanceRangeOk() -> Bool {
        return distance >= lowerDistance && distance <= upperDistance
    }
    
    func isAngleOk() -> Bool {
        return accelerometerService.acceleration.z < topAngle &&
        accelerometerService.acceleration.z > bottomAngle &&
        accelerometerService.acceleration.y > leadingAngle &&
        accelerometerService.acceleration.y < trailingAngle
    }
    
    func handleTopAngleBorder() -> Bool {
        return accelerometerService.acceleration.z > topAngle
    }
    
    func handleBottomAngleBorder() -> Bool {
        return accelerometerService.acceleration.z < bottomAngle
    }
    
    func handleLeadingAngleBorder() -> Bool {
        return accelerometerService.acceleration.y < leadingAngle
    }
    
    func handleTrailingAngleBorder() -> Bool {
        return accelerometerService.acceleration.y > trailingAngle
    }
}
