//  MIT License
//
//  Copyright (c) 2020 Tamerlan Satualdypov
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
import UIKit

@IBDesignable open class STTextView : UITextView {
    
    /// Placeholder string that will be shown in your TextView.
    @IBInspectable public var placeholder : String = "Enter your placeholder" {
        didSet {
            self.placeholderTextView.text = placeholder
        }
    }
    
    /// Color that would be applied to your placeholder text.
    @IBInspectable public var placeholderColor : UIColor = .gray {
        didSet {
            self.placeholderTextView.textColor = placeholderColor
        }
    }
    
    /// If true placeholder text will hide when user starts editing.
    @IBInspectable public var shouldHidePlaceholderOnEditing : Bool = false
    
    /// Attributed placeholder to show your attributed string.
    public var attributedPlaceholder : NSAttributedString? {
        didSet {
            if attributedPlaceholder != nil {
                self.placeholderTextView.text = nil
                self.placeholderTextView.attributedText = attributedPlaceholder
            }
        }
    }
    
    public override var textContainerInset: UIEdgeInsets {
        didSet {
            self.placeholderTextView.textContainerInset = self.textContainerInset
        }
    }
    
    // We have to check if text property is changing at runtime.
    public override var text: String! {
        didSet {
            self.placeholderTextView.isHidden = !self.text.isEmpty
        }
    }
    
    lazy private var placeholderTextView : UITextView = {
        let textView = UITextView()
        
        textView.text = self.placeholder
        textView.textColor = self.placeholderColor
        
        textView.font = self.font
        
        textView.textAlignment = self.textAlignment
        textView.textContainerInset = self.textContainerInset
        
        textView.frame = self.bounds
        
        textView.backgroundColor = .clear
        
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.isHidden = !self.text.isEmpty
        
        return textView
    }()
    
    private var heightConstraint : NSLayoutConstraint?
    private var originHeightConstant : CGFloat?
    
    @objc private func textDidBeginEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if shouldHidePlaceholderOnEditing {
                placeholderTextView.isHidden = true
            }
        }
        updateContentSize()
    }
    
    @objc private func textDidChange(_ notification : Notification) -> () {
        if shouldHidePlaceholderOnEditing {
            if self.text.isEmpty {
                placeholderTextView.isHidden = true
            }
        } else {
            placeholderTextView.isHidden = !self.text.isEmpty
        }
    }
   
    @objc private func textDidEndEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if shouldHidePlaceholderOnEditing {
                placeholderTextView.isHidden = false
            }
        }
        updateContentSize()
    }
    
    // Method is used to update the placeholderTextView whenever
    // the UITextView changes in Interface Builder.
    private func updatePlaceholder() -> () {
        placeholderTextView.text = placeholder
        placeholderTextView.textColor = placeholderColor
        
        placeholderTextView.font = self.font
        placeholderTextView.textAlignment = self.textAlignment
        
        placeholderTextView.frame = self.bounds
    }
    
    // The content should be always visible
    // even if it's just a placeholder text, so
    // this function is solving the problem when a placeholder text
    // did not fit in the UITextView if the height constraint's constant
    // is less than the placeholder text.
    private func updateContentSize() -> () {
        if self.text.isEmpty {
            if let constraint = heightConstraint, let originHeight = originHeightConstant {
                let placeholderContentHeight = placeholderTextView.contentSize.height
                
                if shouldHidePlaceholderOnEditing && isFirstResponder {
                    if originHeight < placeholderContentHeight {
                        constraint.constant = originHeight
                    }
                } else {
                    if constraint.constant < placeholderContentHeight {
                        constraint.constant = placeholderContentHeight
                    }
                }
            }
        }
        
        placeholderTextView.frame = self.bounds
    }
    
    private func signForNotifications() -> () {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextView.textDidChangeNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidBeginEditing(_:)), name: UITextView.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing(_:)), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    private func initialConfiguration() -> () {
        self.insertSubview(placeholderTextView, at: 0)
        
        signForNotifications()
    }
    
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        updatePlaceholder()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // Getting an initial value of the height constraint's constant
        if heightConstraint == nil {
            for constraint in self.constraints {
                if constraint.firstAttribute == .height {
                    heightConstraint = constraint
                    originHeightConstant = constraint.constant
                    break
                }
            }
        }
        
        updateContentSize()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        // To avoid Interface Builder render and auto-layout issues
        super.init(frame: frame, textContainer: textContainer)
        
        initialConfiguration()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialConfiguration()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: nil)
    }
}
