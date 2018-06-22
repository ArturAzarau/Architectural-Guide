//
//  VisionRequestWorker.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 28.05.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import Vision
import UIKit

final class VisionRequestWorker {
    
    typealias Completion = (Int) -> ()
    
    // MARK: - Private properties
    
    private lazy var visionModel: VNCoreMLModel = {
        return try! VNCoreMLModel(for: Pushkin().model)
    }()
    
    // MARK: -
    
    private lazy var visionRequests: [VNRequest] = {
        let request = VNCoreMLRequest(model: visionModel) { (request, error) in
            if error != nil {
//                fatalError("\(error!.localizedDescription)")
                print("\(error!.localizedDescription)")
            }
            
            let observation = request.results?.first as! VNCoreMLFeatureValueObservation
            let multiArrayValue = observation.featureValue.multiArrayValue!
            let object = self.maxValueIndex(withinValues: multiArrayValue)
            DispatchQueue.main.async {
                self.completion(object)
            }
        }
        return [request]
    }()
    
    // MARK: -
    
    private var completion: Completion!
    
    // MARK: - Methods
    
    func performVisionRequest(withImage image: UIImage, completion: @escaping (Int) -> ()) {
        self.completion = completion
        let imageRequestHandler = VNImageRequestHandler(ciImage: CIImage(image: image)!, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform(self.visionRequests)
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Helpers
    
    private func maxValueIndex(withinValues values: MLMultiArray) -> Int {
        var indexOfMaxElem = 0
        let firstElem = values[0] as! Double
        for i in 1..<values.count {
            let element = values[i] as! Double
            if element > firstElem {
                indexOfMaxElem = i
            }
        }
        return indexOfMaxElem
    }
}
