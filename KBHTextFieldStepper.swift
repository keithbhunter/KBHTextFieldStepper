//
//  KBHTextFieldStepper.swift
//  KBHTextFieldStepper
//
//  Created by Keith Hunter on 8/9/15.
//  Copyright © 2015 Keith Hunter. All rights reserved.
//

import UIKit


public class KBHTextFieldStepper: UIControl, UITextFieldDelegate {
    
    // MARK: Public Properties
    
    public var value: Double {
        get { return _value }
        set { self.setValue(newValue) }
    }
    public var minimumValue: Double = 0 {
        didSet {
            if self.value < self.minimumValue {
                self.value = self.minimumValue
            }
        }
    }
    public var maximumValue: Double = 100 {
        didSet {
            if self.value > self.maximumValue {
                self.value = self.maximumValue
            }
        }
    }
    public var stepValue: Double = 1
    public var textFieldDelegate: UITextFieldDelegate? {
        didSet { self.textField.delegate = self.textFieldDelegate }
    }
    public var wraps: Bool = false
    public var autorepeat: Bool = true
    public var continuous: Bool = true
    
    
    // MARK: Private Properties
    
    /// This is private so that no one can mess with the text field's configuration. Use value and textFieldDelegate to control text field customization.
    private var textField: UITextField!
    private let numberFormatter: NSNumberFormatter = {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .DecimalStyle
        return numberFormatter
    }()
    private var _value: Double = 0
    
    /// A timer to implement the functionality of holding down one of the KBHTextFieldStepperButtons. Once started, the run loop will hold a strong reference to the timer, so this property can be weak. The timer is allocated once a button is pressed and deallocated once the button is unpressed.
    private weak var timer: NSTimer?
    
    
    // MARK: Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = .whiteColor()
        
        // Buttons
        let minus = KBHTextFieldStepperButton(origin: CGPointMake(0, 0), type: .Minus)
        let plus = KBHTextFieldStepperButton(origin: CGPointMake(self.frame.size.width - minus.frame.size.width, 0), type: .Plus)
        minus.addTarget(self, action: "minusTouchDown", forControlEvents: .TouchDown)
        minus.addTarget(self, action: "minusTouchUp", forControlEvents: .TouchUpInside)
        plus.addTarget(self, action: "plusTouchDown", forControlEvents: .TouchDown)
        plus.addTarget(self, action: "plusTouchUp", forControlEvents: .TouchUpInside)
        
        // Dividers
        let leftDivider = UIView(frame: CGRectMake(minus.frame.size.width, 0, 1.5, 29))
        let rightDivider = UIView(frame: CGRectMake(self.frame.size.width - plus.frame.size.width, 0, 1.5, 29))
        leftDivider.backgroundColor = self.tintColor
        rightDivider.backgroundColor = self.tintColor
        
        // Text Field
        self.textField = UITextField(frame: CGRectMake(leftDivider.frame.origin.x + leftDivider.frame.size.width, 0, rightDivider.frame.origin.x - (leftDivider.frame.origin.x + leftDivider.frame.size.width), 29))
        self.textField.textAlignment = .Center
        self.textField.text = "0"
        self.textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        self.textField.delegate = self
        
        // Layout:  - | textField | +
        self.addSubview(minus)
        self.addSubview(leftDivider)
        self.addSubview(self.textField)
        self.addSubview(rightDivider)
        self.addSubview(plus)
        
        self.value = self.minimumValue
    }
    
    
    // MARK: Getters/Setters
    
    private func setValue(value: Double) {
        if value > self.maximumValue {
            _value = self.wraps ? self.minimumValue : self.maximumValue
        } else if value < self.minimumValue {
            _value = self.wraps ? self.maximumValue : self.minimumValue
        } else {
            _value = value
        }
        
        self.textField.text = self.numberFormatter.stringFromNumber(NSNumber(double: _value))
    }

    
    // MARK: Drawing
    
    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        self.tintColor.setStroke()
        self.tintColor.setFill()
        
        // Stroke the outside to give the whole view a rounded rect outline
        let outline = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        outline.lineWidth = 1.5
        outline.stroke()
    }
    
    
    // MARK: Actions
    
    internal func minusTouchDown() { self.buttonTouchDown("decrement") }
    internal func plusTouchDown() { self.buttonTouchDown("increment") }
    private func buttonTouchDown(selector: Selector) {
        self.performSelector(selector)
        
        if self.autorepeat {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: selector, userInfo: nil, repeats: true)
        }
    }
    
    internal func minusTouchUp() { self.buttonTouchUp() }
    internal func plusTouchUp() { self.buttonTouchUp() }
    private func buttonTouchUp() {
        guard let timer = self.timer else { return }
        timer.invalidate()
        
        // autorepeat is on since we used a timer. If not continuous, send the only value changed event
        if !self.continuous {
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    internal func decrement() {
        self.value -= self.stepValue
        self.sendValueChangedEvent()
    }
    
    internal func increment() {
        self.value += self.stepValue
        self.sendValueChangedEvent()
    }
    
    private func sendValueChangedEvent() {
        if self.autorepeat && self.continuous {
            self.sendActionsForControlEvents(.ValueChanged)
        } else if !self.autorepeat {
            // If not using autorepeat, this is only called once. Send value changed updates
            self.sendActionsForControlEvents(.ValueChanged)
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        // Allow deleting characters
        if string.characters.count == 0 {
            return true
        }
        
        let legalCharacters = NSCharacterSet.decimalDigitCharacterSet().mutableCopy() as! NSMutableCharacterSet
        legalCharacters.addCharactersInString(".")
        legalCharacters.addCharactersInString("")
        
        if let char = string.utf16.first where legalCharacters.characterIsMember(char) {
            let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            _value = Double(newString)!
            return true
        } else {
            return false
        }
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        if textField.text?.characters.count == 0 {
            self.value = 0
        } else {
            self.value = Double(textField.text!)!
        }
    }

}


// MARK: - Private Classes

private enum KBHTextFieldStepperButtonType {
    case Plus, Minus
}

private class KBHTextFieldStepperButton: UIControl {
    
    private var type: KBHTextFieldStepperButtonType
    
    
    // MARK: Initializers
    
    private required init(origin: CGPoint = CGPointMake(0, 0), type: KBHTextFieldStepperButtonType) {
        self.type = type
        super.init(frame: CGRectMake(origin.x, origin.y, 47, 29))
        self.backgroundColor = .clearColor()
    }
    
    private required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: Drawing
    
    private override func drawRect(rect: CGRect) {
        self.tintColor.setFill()
        
        if self.type == .Minus {
            self.drawMinus()
        } else {
            self.drawPlus()
        }
    }
    
    private func drawMinus() {
        let minus = UIBezierPath(rect: CGRectMake(15.6667, 14.5, 15.6667, 1.5))
        minus.fill()
    }
    
    private func drawPlus() {
        let horiz = UIBezierPath(rect: CGRectMake(15.6667, 14.5, 15.6667, 1.5))
        horiz.fill()
        let vert = UIBezierPath(rect: CGRectMake(23.5, 6.6665, 1.5, 15.6667))
        vert.fill()
    }
    
    
    // MARK: Actions
    
    private override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.sendActionsForControlEvents(.TouchDown)
    }
    
    private override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.sendActionsForControlEvents(.TouchUpInside)
    }
    
}
