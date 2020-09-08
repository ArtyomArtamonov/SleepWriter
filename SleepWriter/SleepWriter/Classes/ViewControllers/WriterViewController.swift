//
//  WriterViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit
import STTextView

class WriterViewController: GradientViewController {
    
    let mainView : UIView = {
        let mainView = UIView()
        
        mainView.layer.cornerRadius = 25
        mainView.backgroundColor = UIColor(hex: "#DCDCDC2B")
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        return mainView
    }()
    
    let textView : STTextView = {
        let textField = STTextView()
        
        textField.textAlignment = .left
        textField.backgroundColor = .clear
        textField.font = UIFont(name: "Rubik-Regular", size: 22)
        textField.textColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.placeholder = "Tap to start"
        textField.placeholderColor = UIColor(white: 0.7, alpha: 1)
//        textField.placeholderAlignment = .center
        textField.placeholderVerticalAlignment = .center
        
        return textField
        
    }()
    
    lazy var saveButton : UIButton = {
        let saveButton = UIButton()
        
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = UIColor(hex: "#00E0FFA2")
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "Rubik-Bold", size: 21)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        return saveButton
    }()
    
    @objc func keyboardHide() -> () {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardHide))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(mainView)
        self.view.addSubview(saveButton)
        self.mainView.addSubview(self.textView)
        
        // Save Button
        NSLayoutConstraint.activate([
            saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        // Main Text Field View
        NSLayoutConstraint.activate([
            mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
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
