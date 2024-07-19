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
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView(frame: .zero)
        arView.delegate = context.coordinator
        arView.session.delegate = context.coordinator
        arView.autoenablesDefaultLighting = true
        arView.automaticallyUpdatesLighting = true
        
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
        }
        
        arView.session.run(configuration)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> ARServiceCoordinator {
        ARServiceCoordinator(self)
    }
}

#Preview {
    ARViewContainer(distance: .constant(0.0))
}
