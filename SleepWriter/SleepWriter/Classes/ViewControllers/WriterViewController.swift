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
        let mainView = UIView(frame: .init(x: self.LEFT_CONST, y: self.titleTextView.frame.maxY, width: blockWidth, height: 30))
        
        mainView.layer.cornerRadius = 25
        mainView.backgroundColor = Colors.light.colors
//        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        return mainView
    }()
    
    lazy var textView : STTextView = {
        let textField = STTextView()
        
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "Rubik-Regular", size: 22)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.tintColor = .white
        
        textField.placeholder = ""
//        textField.placeholderColor = UIColor(white: 0.7, alpha: 1)
////        textField.placeholderAlignment = .center
//        textField.placeholderVerticalAlignment = .center
        
        return textField
        
    }()
    
    lazy var titleTextView : STTextView = {
        let textField = STTextView(frame: .init(x: self.LEFT_CONST, y: self.view.safeAreaLayoutGuide.layoutFrame.minY + 10, width: blockWidth, height: 30))
        
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
        let saveButton = UIButton()
        
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(hex: "#00E0FFA2")
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Bold", size: 21)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        return saveButton
    }()
    
    lazy var helpButton : UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 25
        button.backgroundColor = UIColor(hex: "#00E0FFA2")
        button.setTitle("Help", for: .normal)
        button.titleLabel?.font = UIFont(name: "Rubik-Bold", size: 21)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        
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
        moveBlocks(.down, keyboardPosition: .zero)
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
        UIView.animate(withDuration: 0.3){
            self.mainView.backgroundColor = Colors.light.colors
        }
    }
    
    func moveBlocks(_ to: BlockPosition, keyboardPosition keyboardFrame : CGRect){
        // TODO: move blocks up and down animated;
        if to == .down{
            
        }else{
            
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
        self.mainView.addSubview(self.textView)
        
        // Save Button
        NSLayoutConstraint.activate([
            saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        // Title Text Field
        NSLayoutConstraint.activate([
            titleTextView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            titleTextView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            titleTextView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleTextView.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        // Main Text Field View
        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            mainView.topAnchor.constraint(equalTo: self.titleTextView.safeAreaLayoutGuide.bottomAnchor, constant: 5),
            mainView.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor, constant: -10),
        ])
        
        // Main Text Field
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 15),
            textView.leftAnchor.constraint(equalTo: self.mainView.leftAnchor, constant: 15),
            textView.rightAnchor.constraint(equalTo: self.mainView.rightAnchor, constant: -15),
            textView.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: -15),
        ])
    }

}
