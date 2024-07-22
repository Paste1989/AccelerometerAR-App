//
//  ARCoordinator.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import Foundation
import ARKit

class ARServiceCoordinator: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var parent: ARViewContainer
    var worldTrackingConfig: ARWorldTrackingConfiguration?
    
    init(_ parent: ARViewContainer) {
        self.parent = parent
        super.init()
        setupWorldTrackingConfiguration()
    }
    
    private func setupWorldTrackingConfiguration() {
        worldTrackingConfig = ARWorldTrackingConfiguration()
        worldTrackingConfig?.planeDetection = .vertical
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let imageAnchor = anchor as? ARImageAnchor else { return nil }
        
        let node = SCNNode()
        let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                             height: imageAnchor.referenceImage.physicalSize.height)
        
        plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
        let planeNode = SCNNode(geometry: plane)
        planeNode.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode)
        
        // Switch to world tracking configuration after detecting the image
        if let worldTrackingConfig = worldTrackingConfig {
            DispatchQueue.main.async { [weak self] in
                if let arView = renderer as? ARSCNView {
                    arView.session.run(worldTrackingConfig, options: [.removeExistingAnchors, .resetTracking])
                }
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
            
            DispatchQueue.main.async {
                self.parent.distance = distance
            }
        }
        
        if worldTrackingConfig != nil {
            for anchor in currentFrame.anchors {
                if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical {
                    // Perform actions upon detecting a vertical surface
                    
                    let anchorPosition = SCNVector3(planeAnchor.transform.columns.3.x, planeAnchor.transform.columns.3.y, planeAnchor.transform.columns.3.z)
                    let distance = distanceBetweenPoints(cameraPosition, anchorPosition)
                    
                    DispatchQueue.main.async {
                        self.parent.distance = distance
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
