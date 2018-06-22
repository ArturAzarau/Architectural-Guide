//
//  NodeFactoryWorker.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 28.05.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import SceneKit
import ARKit
import UIKit

final class NodeFactoryWorker {
    
    // MARK: - Object Life cycle
    
    init(view: UIView) {
        self.infoView = view
    }
    
    // MARK: - Private properties
    
    private let infoView: UIView
    
    private let infoDict: [Int: String] = [
        0 : "None of the objects",
        1 : {
            if let filepath = Bundle.main.path(forResource: "PushkinInformation", ofType: "txt") {
                    let contents = try! String(contentsOfFile: filepath)
                    return contents
            }
            return ""
        }()
    ]
    
    // MARK: -
    
    private lazy var node:SCNNode = {
        let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.35))
        plane.firstMaterial?.fillMode = .fill
        plane.cornerRadius = 0.007
        plane.firstMaterial?.diffuse.contents = self.infoView
        let planeNode = SCNNode()
        planeNode.geometry = plane
        return planeNode
    }()
    
    // MARK: -
    
    func positionedNode(withFrame currentFrame: ARFrame, texture: UITextView, and object: Int) -> SCNNode {
        texture.text = infoDict[object]
        let node = self.node
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.35
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        node.rotation = SCNVector4(0,0,1, currentFrame.camera.eulerAngles.z)
        node.rotation = SCNVector4(0,1,0, currentFrame.camera.eulerAngles.y)
        return node
    }
}
