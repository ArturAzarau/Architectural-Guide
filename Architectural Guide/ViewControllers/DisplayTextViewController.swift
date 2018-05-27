//
//  DisplayTextViewController.swift
//  Architectural Guide
//
//  Created by Артур Азаров on 26.05.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import UIKit

final class DisplayTextViewController: UIViewController {
    weak var delegate: UITextViewPinchDelegate?
    @IBOutlet var textView: UITextView!
    
    @IBAction func pinched(_ sender: UIPinchGestureRecognizer) {
        delegate?.textView(textView, didPinchWith: Float(sender.scale))
    }
    
}

protocol UITextViewPinchDelegate: class {
    func textView(_ textView: UITextView, didPinchWith scale: Float)
}
