# KBHTextFieldStepper

A `UIStepper` with a `UITextField` in the middle. Default implementation restricts the `UITextField`'s text to `Double`.

![Alt text](https://github.com/keithbhunter/KBHTextFieldStepper/blob/master/Images/TextFieldStepper.gif "KBHTextFieldStepper")


## Usage

Create a UIView in the storyboard and set the class to KBHTextFieldStepper or create it in code. The width is fixed, so make sure there is enough room to display the text you may have.

```
self.textFieldStepper = KBHTextFieldStepper(frame: CGRectMake(16, 28, 150, 29))
self.view.addSubview(textFieldStepper)
``` 

## License

KBHTextFieldStepper is available under the MIT license. See the LICENSE file for more info.