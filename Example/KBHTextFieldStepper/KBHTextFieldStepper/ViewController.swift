//
//  ViewController.swift
//  KBHTextFieldStepper
//
//  Created by Keith Hunter on 8/9/15.
//  Copyright © 2015 Keith Hunter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let textFieldStepper = KBHTextFieldStepper(frame: CGRectMake(16, 28, 150, 29))
        self.view.addSubview(textFieldStepper)
    }
    
}

