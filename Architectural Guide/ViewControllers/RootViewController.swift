//
//  ViewController.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 25.05.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreML
import Vision

final class RootViewController: UIViewController, ARSCNViewDelegate {

    private var recentNode: SCNNode!
    private var textViewVC: DisplayTextViewController!
    private var shaphot: UIImage {
        return self.sceneView.snapshot()
    }
    
    private lazy var visionModel: VNCoreMLModel = {
        return try! VNCoreMLModel(for: Pushkin().model)
    }()
    
    private lazy var infoView: UIView? = {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "TextViewVC") as? DisplayTextViewController else {
            return nil
        }
        vc.delegate = self
        self.textViewVC = vc
        return vc.view
    }()
    
    private lazy var node: SCNNode = {
        let plane = SCNPlane(width: CGFloat(0.2), height: CGFloat(0.35))
        plane.firstMaterial?.fillMode = .fill
        plane.firstMaterial?.diffuse.contents = self.infoView
        let planeNode = SCNNode()
        planeNode.geometry = plane
        return planeNode
    }()
    
    private var positionedNode: SCNNode? {
        guard let currentFrame = self.sceneView.session.currentFrame else { return nil }
        let node = self.node
        var translation = matrix_identity_float4x4
        translation.columns.3.z = -0.35
        node.simdTransform = matrix_multiply(currentFrame.camera.transform, translation)
        node.rotation = SCNVector4(0,0,1, currentFrame.camera.eulerAngles.z)
        node.rotation = SCNVector4(0,1,0, currentFrame.camera.eulerAngles.y)
        return node
    }
    
    @IBOutlet var sceneView: ARSCNView!
    
    private lazy var visionRequests: [VNRequest] = {
        let request = VNCoreMLRequest(model: visionModel) { (request, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            let observation = request.results?.first as! VNCoreMLFeatureValueObservation
            let multiArrayValue = observation.featureValue.multiArrayValue
            let zeroResult = multiArrayValue![0] as! Double
            let firstResult = multiArrayValue![1] as! Double
            if firstResult > zeroResult {
                DispatchQueue.main.async {
                    if self.recentNode != nil {
                        self.recentNode.removeFromParentNode()
                    }
                    guard let positionedNode = self.positionedNode else { fatalError("Cannot find positionedNode") }
                    self.sceneView.scene.rootNode.addChildNode(positionedNode)
                    self.recentNode = positionedNode
                }
            }
        }
        return [request]
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
        registerGestureRecogners()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    private func registerGestureRecogners() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func tapped(recognizer: UITapGestureRecognizer) {
        performVisionRequest(image: self.shaphot)
    }
    
    private func performVisionRequest(image: UIImage) {
        let imageRequestHandler = VNImageRequestHandler(ciImage: CIImage(image: image)!, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try! imageRequestHandler.perform(self.visionRequests)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

extension RootViewController: UITextViewPinchDelegate {
    func textView(_ textView: UITextView, didPinchWith scale: Float) {
        recentNode.scale = SCNVector3Make(scale, scale, scale)
    }
}
