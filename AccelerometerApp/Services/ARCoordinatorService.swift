//
//  ARCoordinator.swift
//  AccelerometerApp
//
//  Created by Saša Brezovac on 15.07.2024..
//

import Foundation
import ARKit
import RealityKit
import SpriteKit
import SceneKit
import ImageIO

class ARCoordinatorService: NSObject, ARSCNViewDelegate, ARSessionDelegate {
    var parent: ARViewContainer
    var worldTrackingConfig: ARWorldTrackingConfiguration?
    var imageTrackingConfig: ARImageTrackingConfiguration?
    
    let allGIFs: [ImageGIF] = ImageGIF.allGifs
    
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
        
        if let name = imageAnchor.name, name.contains("step") {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                 height: imageAnchor.referenceImage.physicalSize.height)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            
            for i in allGIFs {
                print("gif name: \(i.rawValue) == anch: \(name)")
                if name.contains(i.rawValue) {
                    if let gifScene = createGifSKScene(gifName: i.rawValue, size: CGSize(width: 1024, height: 1024)) {
                        plane.firstMaterial?.diffuse.contents = gifScene
                        node.addChildNode(planeNode)
                    }
                    else {
                        plane.firstMaterial?.diffuse.contents = UIColor.green.withAlphaComponent(0.7)
                        node.addChildNode(planeNode)
                    }
                }
            }
            
            return node
            
        } else {
            if let arView = renderer as? ARSCNView {
                setupWorldTrackingConfiguration(arView: arView)
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
    
    func createGifSKScene(gifName: String, size: CGSize) -> SKScene? {
        guard let gifURL = Bundle.main.url(forResource: gifName, withExtension: "gif"),
              let gifData = try? Data(contentsOf: gifURL) else { return nil }
        
        let gifOptions = [kCGImageSourceShouldCache as String: false]
        guard let gifSource = CGImageSourceCreateWithData(gifData as CFData, gifOptions as CFDictionary) else { return nil }
        
        let gifCount = CGImageSourceGetCount(gifSource)
        var frames = [SKTexture]()
        var duration: TimeInterval = 0
        
        for i in 0..<gifCount {
            if let frame = CGImageSourceCreateImageAtIndex(gifSource, i, gifOptions as CFDictionary) {
                let properties = CGImageSourceCopyPropertiesAtIndex(gifSource, i, nil) as? [CFString: Any]
                let gifProperties = properties?[kCGImagePropertyGIFDictionary] as? [CFString: Any]
                let delayTime = (gifProperties?[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval)
                ?? (gifProperties?[kCGImagePropertyGIFDelayTime] as? TimeInterval)
                ?? 0.1
                
                duration += delayTime
                let texture = SKTexture(cgImage: frame)
                frames.append(texture)
            }
        }
        
        let spriteScene = SKScene(size: size)
        let spriteNode = SKSpriteNode(texture: frames.first)
        spriteNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
        spriteScene.addChild(spriteNode)
        
        spriteNode.run(SKAction.repeatForever(
            SKAction.animate(with: frames, timePerFrame: duration / Double(frames.count))
        ))
        
        return spriteScene
    }
}
