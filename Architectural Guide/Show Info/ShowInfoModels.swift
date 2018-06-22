//
//  ShowInfoModels.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 27.05.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import CoreML
import UIKit
import ARKit

enum ShowInfo
{
    enum ShowInfoView {
        struct Request {
            let image: UIImage
            let currentFrame: ARFrame
        }
        
        struct Response {
            let node: SCNNode
        }
        
        struct ViewModel {
            let node: SCNNode
        }
    }
    
    enum ZoomView {
        struct Response {
            let scale: Float
        }
        struct ViewModel {
            let scale: Float
        }
    }
}
