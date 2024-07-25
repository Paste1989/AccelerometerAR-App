//
//  ARViewContainer.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import SwiftUI
import ARKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var distance: Float
    var onVerticalSurfaceDetected: (() -> Void)?
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        arView.autoenablesDefaultLighting = true
        arView.automaticallyUpdatesLighting = true

        context.coordinator.setupImageTrackingConfiguration(arView: arView)

        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {
        if context.coordinator.worldTrackingConfig != nil {
            DispatchQueue.main.async {
                self.onVerticalSurfaceDetected?()
            }
            
        }
    }
    
    func makeCoordinator() -> ARCoordinatorService {
        ARCoordinatorService(self)
    }
}

#Preview {
    ARViewContainer(distance: .constant(0.0))
}
