//
//  KBHTextFieldStepper.swift
//  KBHTextFieldStepper
//
//  Created by Keith Hunter on 8/9/15.
//  Copyright © 2015 Keith Hunter. All rights reserved.
//

import UIKit

//  + and - button are 47 x 29

class KBHTextFieldStepper: UIControl {
    
    // MARK: - Initializers
    
    init() {
        let theFrame = CGRectMake(0, 0, 94, 29)
        super.init(frame: theFrame)
        self.setup()
    }
    
    override init(frame: CGRect) {
        let theFrame = CGRectMake(frame.origin.x, frame.origin.y, 94, 29)
        super.init(frame: theFrame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.addSubview(KBHTextFieldStepperButton(origin: CGPointMake(0, 0), type: .Minus))
        self.addSubview(KBHTextFieldStepperButton(origin: CGPointMake(47, 0), type: .Plus))
        self.backgroundColor = .whiteColor()
    }

    
    // MARK: - Drawing
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.tintColor.setStroke()
        self.tintColor.setFill()
        
        let outline = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        outline.lineWidth = 1.5
        outline.stroke()
        
        let divider = UIBezierPath(rect: CGRectMake(rect.size.width / 2.0, 0, 1.5, rect.size.height))
        divider.fill()
    }

}


private enum KBHTextFieldStepperButtonType {
    case Plus, Minus
}

private class KBHTextFieldStepperButton: UIControl {
    
    var type: KBHTextFieldStepperButtonType
    
    
    // MARK: - Initializers
    
    required init(origin: CGPoint = CGPointMake(0, 0), type: KBHTextFieldStepperButtonType) {
        self.type = type
        super.init(frame: CGRectMake(origin.x, origin.y, 47, 29))
        self.backgroundColor = .clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Drawing
    
    private override func drawRect(rect: CGRect) {
        self.tintColor.setFill()
        
        if self.type == .Minus {
            self.drawMinus()
        } else {
            self.drawPlus()
        }
    }
    
    private func drawMinus() {
        let minus = UIBezierPath(rect: CGRectMake(15.6667, 14.5, 15.6667, 1))
        minus.fill()
    }
    
    private func drawPlus() {
        let horiz = UIBezierPath(rect: CGRectMake(15.6667, 14.5, 15.6667, 1))
        horiz.fill()
        let vert = UIBezierPath(rect: CGRectMake(23.5, 6.6665, 1, 15.6667))
        vert.fill()
    }
    
}
