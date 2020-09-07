//
//  WriterViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class WriterViewController: GradientViewController {
    
    lazy var textField : UIView = {
        let mainView = UIView()
        let textField = UITextField()
        
        mainView.layer.cornerRadius = 25
        mainView.backgroundColor = UIColor(hex: "#DCDCDC2B")
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.textAlignment = .left
        textField.contentVerticalAlignment = .top
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 15),
            textField.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 15),
            textField.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -15),
            textField.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -15),
        ])
        
        
        
        return mainView
    }()
    
    lazy var textFieldPlaceholder : UILabel = {
        let textFieldPlaceholder = UILabel()
        
        textFieldPlaceholder.text = "Tap to start"
        textFieldPlaceholder.textColor = UIColor(white: 0.7, alpha: 1)
        textFieldPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        
        return textFieldPlaceholder
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(textField)
        self.view.addSubview(saveButton)
        self.view.addSubview(textFieldPlaceholder)
        
        // Save Button
        NSLayoutConstraint.activate([
            saveButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            saveButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            saveButton.heightAnchor.constraint(equalToConstant: 70),
            saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
        ])
        
        // Main Text Field
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 15),
            textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -15),
            textField.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.bottomAnchor.constraint(equalTo: self.saveButton.topAnchor, constant: -10),
        ])
        
        // Main Text Field Placeholder
        NSLayoutConstraint.activate([
            textFieldPlaceholder.centerXAnchor.constraint(equalTo: self.textField.centerXAnchor),
            textFieldPlaceholder.centerYAnchor.constraint(equalTo: self.textField.centerYAnchor),
            textFieldPlaceholder.heightAnchor.constraint(equalToConstant: 30),
            textFieldPlaceholder.widthAnchor.constraint(equalToConstant: 100),
            
        ])
        
        
        
        
        
    }

}
