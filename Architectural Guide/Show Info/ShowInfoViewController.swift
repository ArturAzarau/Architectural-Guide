//
//  ShowInfoViewController.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 27.05.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import ARKit

protocol ShowInfoDisplayLogic: class
{
    func displayInfoView(viewModel: ShowInfo.ShowInfoView.ViewModel)
    func displayZooom(viewModel: ShowInfo.ZoomView.ViewModel)
}

final class ShowInfoViewController: UIViewController, ShowInfoDisplayLogic
{
    var interactor: ShowInfoBusinessLogic?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ShowInfoInteractor()
        let presenter = ShowInfoPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }
    
    // MARK: Classify Object
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBAction func classifyObject(_ sender: UITapGestureRecognizer) {
        guard let currentFrame = sceneView.session.currentFrame else {
            fatalError("Cannot take current frame")
        }
        
        let image = sceneView.snapshot()
        let request = ShowInfo.ShowInfoView.Request(image: image, currentFrame: currentFrame)
        interactor?.performVisionRequest(request: request)
    }
    
    func displayInfoView(viewModel: ShowInfo.ShowInfoView.ViewModel) {
        sceneView.scene.rootNode.childNodes.first?.removeFromParentNode()
        sceneView.scene.rootNode.addChildNode(viewModel.node)
    }
    
    // MARK: - Display Zoom
    
    func displayZooom(viewModel: ShowInfo.ZoomView.ViewModel) {
        let scale = viewModel.scale
        sceneView.scene.rootNode.childNodes.first?.scale = SCNVector3Make(scale, scale, scale)
    }
}
