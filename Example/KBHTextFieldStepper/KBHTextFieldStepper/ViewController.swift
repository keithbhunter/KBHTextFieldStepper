//
//  ViewController.swift
//  KBHTextFieldStepper
//
//  Created by Keith Hunter on 8/9/15.
//  Copyright © 2015 Keith Hunter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textFieldStepper: KBHTextFieldStepper!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(KBHTextFieldStepper(frame: CGRectMake(16, 28, 150, 29)))
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

}

