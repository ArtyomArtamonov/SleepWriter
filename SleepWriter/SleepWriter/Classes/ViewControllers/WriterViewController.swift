//
//  WriterViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit
import STTextView

class WriterViewController: UIViewController {
    
    internal enum Colors {
        case dark, light
        
        public var colors: UIColor {
            switch self {
            case .light:
                return UIColor(white: 1, alpha: 0.1)//UIColor(hex: "#0000005B")!
            case .dark:
                return UIColor(white: 0, alpha: 0.2)//UIColor(hex: "#1499A62B")!
            }
        }
    }
    
    internal enum BlockPosition {
        case up, down
    }
    
    let LEFT_CONST : CGFloat = 15
    lazy var blockWidth : CGFloat = self.view.frame.size.width - LEFT_CONST*2
    
    var dreamsViewControllerDelegate : DreamsViewControllerDelegate
    
    lazy var mainView : UIView = {
        let mainView = UIView(frame: .init(x: self.LEFT_CONST, y: titleTextView.frame.maxY, width: self.blockWidth, height: self.helpButton.frame.minY - titleTextView.frame.maxY - 15))
        
        mainView.layer.cornerRadius = 25
        mainView.backgroundColor = Colors.light.colors
//        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        return mainView
    }()
    
    lazy var textView : STTextView = {
        let textField = STTextView(frame: .init(x: 10, y: 10, width: self.mainView.frame.width - 10, height: self.mainView.frame.height-10))
        
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "Rubik-Regular", size: 22)
        textField.textColor = .white
//        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .white
        
        textField.placeholder = ""
//        textField.placeholderColor = UIColor(white: 0.7, alpha: 1)
////        textField.placeholderAlignment = .center
        textField.placeholderVerticalAlignment = .center
        
        return textField
        
    }()
    
    lazy var titleTextView : STTextView = {
        let textField = STTextView(frame: .init(x: LEFT_CONST, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 20, width: self.blockWidth, height: 50))
        
        textField.textAlignment = .center
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "Rubik-Bold", size: 26)
        textField.textColor = .white
        textField.textContainer.maximumNumberOfLines = 1
        textField.textContainer.lineBreakMode = .byTruncatingTail
//        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .white
        
        
        textField.placeholder = "Title"
        textField.placeholderFont = UIFont(name: "Rubik-Bold", size: 26)!
        textField.placeholderColor = .white
        textField.placeholderAlignment = .center
        textField.shouldHidePlaceholderOnEditing = true
        //        textField.placeholderColor = UIColor(white: 0.7, alpha: 1)
        ////        textField.placeholderAlignment = .center
        //        textField.placeholderVerticalAlignment = .center
                
        return textField
    }()
    
    lazy var saveButton : UIButton = {
        let saveButton = UIButton(frame: .init(x: self.helpButton.frame.maxX + 10, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 85, width: self.blockWidth/2 - 5, height: 55))
        
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(hex: "#00E0FFA2")
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Bold", size: 21)
//        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return saveButton
    }()
    
    lazy var helpButton : UIButton = {
        let button = UIButton(frame: .init(x: LEFT_CONST, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 85, width: self.blockWidth/2 - 5, height: 55))
        
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(hex: "#00E0FFA2")
        button.setTitle("Help", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Bold", size: 21)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return button
    }()
    
    @objc func saveButtonPressed(){
        let newDream : Dream = Dream(date: Float(Date().timeIntervalSince1970), title: titleTextView.text, text: textView.text, last_opened: Float(Date().timeIntervalSince1970))
        
        guard newDream.title != "" else {return;}
        guard newDream.text != "" else {return;}
        guard !isDreamExists(newDream) else {return;}
        
        
        var data = loadDreams()
        
        data.append(newDream)
        
        try? JSONSerialization.save(jsonObject: data, toFilename: fileName)
        self.dreamsViewControllerDelegate.updateCells()
                
        
    }
    
    @objc func keyboardHide() -> () {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue
        
        moveBlocks(.up, keyboardPosition: keyboardFrame)
        
        UIView.animate(withDuration: 0.3){
            self.mainView.backgroundColor = Colors.dark.colors
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification){
        moveBlocks(.down, keyboardPosition: .zero)
        UIView.animate(withDuration: 0.3){
            self.mainView.backgroundColor = Colors.light.colors
        }
    }
    
    func moveBlocks(_ position: BlockPosition, keyboardPosition keyboardFrame : CGRect){
        // TODO: move blocks up and down animated;
        let animationTimeInterval : TimeInterval = 0.5
        
        if position == .down{
            UIView.animate(withDuration: animationTimeInterval){
                self.constraintsToBottomBlocks()
            }
        }else{
            UIView.animate(withDuration: animationTimeInterval){
                self.constraintsToUpBlocks(keyboardFrame)
            }
        }
    }
    
    func loadDreams() -> [Dream]{
        do{
            return try JSONSerialization.loadJSON(withFilename: fileName) as! [Dream]
        }catch{
            return []
        }
    }
    
    func isDreamExists(_ dream : Dream) -> Bool{
        let dreams = loadDreams()
        
        for savedDream in dreams{
            if dream.text == savedDream.text{
                return true
            }
        }
        
        return false
    }
    
    init(dreamsViewControllerDelegate : DreamsViewControllerDelegate) {
        self.dreamsViewControllerDelegate = dreamsViewControllerDelegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(mainView)
        self.view.addSubview(saveButton)
        self.view.addSubview(titleTextView)
        self.view.addSubview(helpButton)
        self.mainView.addSubview(self.textView)
        
    }
    
    func constraintsToUpBlocks(_ keyboard : CGRect){
        helpButton.frame = .init(x: LEFT_CONST, y: keyboard.minY - 85, width: self.blockWidth/2 - 5, height: 55)
        
        saveButton.frame = .init(x: self.helpButton.frame.maxX + 10, y: keyboard.minY - 85, width: self.blockWidth/2 - 5, height: 55)
        
        mainView.frame = .init(x: self.LEFT_CONST, y: titleTextView.frame.maxY, width: self.blockWidth, height: self.helpButton.frame.minY - titleTextView.frame.maxY - 15)
        
        textView.frame = .init(x: 10, y: 10, width: self.mainView.frame.width - 10, height: self.mainView.frame.height-10)
    }
    
    func constraintsToBottomBlocks(){
        helpButton.frame = .init(x: LEFT_CONST, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 85, width: self.blockWidth/2 - 5, height: 55)
        
        saveButton.frame = .init(x: self.helpButton.frame.maxX + 10, y: self.view.safeAreaLayoutGuide.layoutFrame.maxY - 85, width: self.blockWidth/2 - 5, height: 55)
        
        mainView.frame = .init(x: self.LEFT_CONST, y: titleTextView.frame.maxY, width: self.blockWidth, height: self.helpButton.frame.minY - titleTextView.frame.maxY - 15)
        
        textView.frame = .init(x: 10, y: 10, width: self.mainView.frame.width - 10, height: self.mainView.frame.height-10)
    }

}
