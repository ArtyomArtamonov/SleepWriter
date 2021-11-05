//
//  EmptyView.swift
//  SleepWriter
//
//  Created by Sam Greenhill on 11/4/21.
//  Copyright © 2021 Artyom Artamonov. All rights reserved.
//

import Foundation
import UIKit

class EmptyView: UIView {
    
    
    var emptyLbl = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpView()
    }
    
    //Can change font and text for emptyLbl here
    private func setUpView() {
        backgroundColor = UIColor.applicationDarkColor
        emptyLbl.text = "Create a dream"
        
        emptyLbl.textAlignment = .center
        emptyLbl.numberOfLines = 0
        self.addSubview(emptyLbl)
        self.layer.cornerRadius = 25.0
        emptyLbl.font = UIFont(name: "Rubik-Bold", size: 25.0)
        emptyLbl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyLbl.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            emptyLbl.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            emptyLbl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            emptyLbl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
        
        
    }
    
    
    
}
