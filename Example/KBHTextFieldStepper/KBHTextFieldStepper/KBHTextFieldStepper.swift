//
//  KBHTextFieldStepper.swift
//  KBHTextFieldStepper
//
//  Created by Keith Hunter on 8/9/15.
//  Copyright © 2015 Keith Hunter. All rights reserved.
//

import UIKit

class KBHTextFieldStepper: UIControl {

    override func drawRect(rect: CGRect) {
        self.tintColor.setStroke()
        self.tintColor.setFill()
        
        let outline = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        outline.lineWidth = 1.5
        outline.stroke()
        
        let divider = UIBezierPath(rect: CGRectMake(rect.size.width / 2.0, 0, 1.5, rect.size.height))
        divider.fill()
    }

}
