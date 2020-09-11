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
    
    
    
    
// ART3A
    
    public var placeholderFont : UIFont = .boldSystemFont(ofSize: 25){
        didSet {
            self.placeholderTextView.font = placeholderFont
        }
    }
    
    /// Alignment of placeholder
    public var placeholderAlignment : NSTextAlignment = .left{
        didSet {
            self.placeholderTextView.textAlignment = placeholderAlignment
        }
    }
    
    /// Vertical alignment of placeholder
    public var placeholderVerticalAlignment : UIControl.ContentMode = .topLeft{
        didSet {
//            var edges = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            var constraints : [NSLayoutConstraint] = []
            let pva = placeholderVerticalAlignment
            
            if(pva == .topLeft || pva == .top || pva == .topRight){
                constraints.append(placeholderTextView.topAnchor.constraint(equalTo: self.topAnchor))
            }
            else if(pva == .bottom || pva == .bottomLeft || pva == .bottomRight){
                constraints.append(placeholderTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor))
            }
            
            if(pva == .center){
                constraints.append(placeholderTextView.centerYAnchor.constraint(equalTo: self.centerYAnchor))
                constraints.append(placeholderTextView.centerXAnchor.constraint(equalTo: self.centerXAnchor))
                constraints.append(placeholderTextView.widthAnchor.constraint(equalToConstant: 100))
                constraints.append(placeholderTextView.heightAnchor.constraint(equalToConstant: 30))
                placeholderTextView.textAlignment = .center
            }
            // TODO: make placeholder centered
            NSLayoutConstraint.activate(constraints)
        }
    
    }
    
// /ART3A
    
    
    
    // We have to check if text property is changing at runtime.
    public override var text: String! {
        didSet {
            self.placeholderTextView.isHidden = !self.text.isEmpty
        }
    }
    
    public override var contentInset: UIEdgeInsets {
        didSet {
            self.placeholderTextView.contentInset = self.contentInset
        }
    }
    
    lazy private var placeholderTextView : UITextView = {
        let textView = UITextView()
        
        textView.text = self.placeholder
        textView.textColor = self.placeholderColor
        
        textView.font = self.font
        
        textView.textAlignment = self.textAlignment
        textView.contentInset = self.contentInset
        
        textView.frame = self.bounds
        
        textView.backgroundColor = .clear
        
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    @objc private func textDidBeginEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if shouldHidePlaceholderOnEditing {
                placeholderTextView.isHidden = true
            }
        }
    }
    
    @objc private func textDidChange(_ notification : Notification) -> () {
        placeholderTextView.isHidden = !self.text.isEmpty
    }
   
    @objc private func textDidEndEditing(_ notification : Notification) -> () {
        if self.text.isEmpty {
            if shouldHidePlaceholderOnEditing {
                placeholderTextView.isHidden = false
            }
        }
    }
    
    // Method is used to update the placeholderTextView whenever
    // the TextView changes in Interface Builder.
    private func updatePlaceholder() -> () {
        placeholderTextView.text = placeholder
        placeholderTextView.textColor = placeholderColor
        
        placeholderTextView.font = self.font
        placeholderTextView.textAlignment = self.textAlignment
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
        
        placeholderTextView.frame = self.bounds
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
