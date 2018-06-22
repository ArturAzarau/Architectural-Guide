//
//  ShowInfoInteractor.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 27.05.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit
import Vision

protocol ShowInfoBusinessLogic
{
    func performVisionRequest(request: ShowInfo.ShowInfoView.Request)
}

final class ShowInfoInteractor: ShowInfoBusinessLogic
{
    var presenter: ShowInfoPresentationLogic?
    
    // MARK: - Private properties
    
    private let visionRequestWorker = VisionRequestWorker()
    private lazy var nodeFactoryWorker = NodeFactoryWorker(view: vc.view)
    
    private lazy var vc: DisplayTextViewController = {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TextViewVC")  as? DisplayTextViewController else {
            return DisplayTextViewController()
        }
        vc.delegate = self
        return vc
    }()
    
    // MARK: -
    
    // MARK: Vision Request
    
    func performVisionRequest(request: ShowInfo.ShowInfoView.Request) {
        let image = request.image
        visionRequestWorker.performVisionRequest(withImage: image) { [unowned self] (object) in
            let node = self.nodeFactoryWorker.positionedNode(withFrame: request.currentFrame, texture: self.vc.textView, and: object)
            let response = ShowInfo.ShowInfoView.Response(node: node)
            self.presenter?.presentView(response: response)
        }
    }
}

extension ShowInfoInteractor: UITextViewPinchDelegate {
    func textView(_ textView: UITextView, didPinchWith scale: Float) {
        let response = ShowInfo.ZoomView.Response(scale: scale)
        presenter?.presentZoom(response: response)
    }
}
