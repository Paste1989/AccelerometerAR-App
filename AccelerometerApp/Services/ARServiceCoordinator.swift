//
//  ARCoordinator.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import Foundation
import ARKit
import RealityKit

class ARServiceCoordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var parent: ARViewContainer
    var worldTrackingConfig: ARWorldTrackingConfiguration?
    var imageTrackingConfig: ARImageTrackingConfiguration?
    
    
    init(_ parent: ARViewContainer) {
        self.parent = parent
        super.init()
    }
    
    func setupWorldTrackingConfiguration(arView: ARSCNView) {
        imageTrackingConfig = nil
        
        worldTrackingConfig = ARWorldTrackingConfiguration()
        worldTrackingConfig?.planeDetection = .vertical
        
        DispatchQueue.main.async { [weak self] in
            arView.session.run(self?.worldTrackingConfig ?? ARWorldTrackingConfiguration(), options: [.removeExistingAnchors, .resetTracking])
            print("---> worldTrackingConfig SETUP")
        }
    }
    
    func setupImageTrackingConfiguration(arView: ARSCNView) {
        worldTrackingConfig = nil
        
        imageTrackingConfig = ARImageTrackingConfiguration()
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil) {
            imageTrackingConfig?.trackingImages = trackedImages
            imageTrackingConfig?.maximumNumberOfTrackedImages = 1
        }
        
        DispatchQueue.main.async { [weak self] in
            arView.session.run(self?.imageTrackingConfig ?? ARImageTrackingConfiguration(), options: [.removeExistingAnchors, .resetTracking])
            print("---> imageTrackingConfig SETUP")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        let node = SCNNode()
        
        // Switch to world tracking configuration after detecting the image
        if let name = imageAnchor.name {
            if !name.contains("step") {
                if let arView = renderer as? ARSCNView {
                    setupWorldTrackingConfiguration(arView: arView)
                }
            }
            else {
                if imageTrackingConfig == nil {
                    if let arView = renderer as? ARSCNView {
                        setupImageTrackingConfiguration(arView: arView)
                    }
                }
                
                let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                     height: imageAnchor.referenceImage.physicalSize.height)
                
                plane.firstMaterial?.diffuse.contents = UIColor.red
                let planeNode = SCNNode(geometry: plane)
                planeNode.eulerAngles.x = -.pi / 2
                
                node.addChildNode(planeNode)
                return node
            }
        }
        
        return node
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        guard let currentFrame = session.currentFrame else { return }
        guard let cameraTransform = session.currentFrame?.camera.transform else { return }
        
        let cameraPosition = SCNVector3(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        
        if let anchors = currentFrame.anchors as? [ARImageAnchor], let imageAnchor = anchors.first {
            let anchorPosition = SCNVector3(imageAnchor.transform.columns.3.x, imageAnchor.transform.columns.3.y, imageAnchor.transform.columns.3.z)
            
            let distance = distanceBetweenPoints(cameraPosition, anchorPosition)
            
            DispatchQueue.main.async { [weak self] in
                self?.parent.distance = distance
            }
        }
        
        if worldTrackingConfig != nil {
            for anchor in currentFrame.anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical {
                    // Perform actions upon detecting a vertical surface
                    
                    let anchorPosition = SCNVector3(planeAnchor.transform.columns.3.x, planeAnchor.transform.columns.3.y, planeAnchor.transform.columns.3.z)
                    let distance = distanceBetweenPoints(cameraPosition, anchorPosition)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.parent.distance = distance
                    }
                }
            }
        }
    }
    
    func distanceBetweenPoints(_ pointA: SCNVector3, _ pointB: SCNVector3) -> Float {
        let dx = pointA.x - pointB.x
        let dy = pointA.y - pointB.y
        let dz = pointA.z - pointB.z
        return sqrt(dx * dx + dy * dy + dz * dz)
    }
}
