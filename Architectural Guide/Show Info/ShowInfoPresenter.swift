//
//  ShowInfoPresenter.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 27.05.2018.
//  Copyright (c) 2018 Артур Азаров. All rights reserved.
//

import UIKit
import CoreML

protocol ShowInfoPresentationLogic
{
    func presentView(response: ShowInfo.ShowInfoView.Response)
    func presentZoom(response: ShowInfo.ZoomView.Response)
}

final class ShowInfoPresenter: ShowInfoPresentationLogic
{
    weak var viewController: ShowInfoDisplayLogic?
    
    // MARK: Present View
    
    
    func presentView(response: ShowInfo.ShowInfoView.Response) {
        let node = response.node
        let viewModel = ShowInfo.ShowInfoView.ViewModel(node: node)
        viewController?.displayInfoView(viewModel: viewModel)
    }
    
    // MARK: - Present Zoom
    
    func presentZoom(response: ShowInfo.ZoomView.Response) {
        let scale = response.scale
        let viewModel = ShowInfo.ZoomView.ViewModel(scale: scale)
        viewController?.displayZooom(viewModel: viewModel)
    }
}
