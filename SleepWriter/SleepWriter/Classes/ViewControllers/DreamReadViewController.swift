//
//  DreamReadViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 13.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamReadViewController: UIViewController {
    
    var dream : Dream!
    
    lazy var titleLabel : UILabel = {
        let label = UILabel(frame: .init(x: 10, y: 5, width: self.view.frame.size.width, height: 40))
        label.font = UIFont(name: "Rubik-Bold", size: 26)
        label.textColor = .white
        label.textAlignment = .center
        label.text = self.dream.title
        label.numberOfLines = 0
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var dateLabel : UILabel = {
        let label = UILabel(frame: .init(x: 0, y: self.titleLabel.frame.maxY+10, width: self.view.frame.size.width, height: 20))
        label.font = UIFont(name: "Rubik-Regular", size: 18)
        label.textColor = UIColor(white: 1, alpha: 0.7)
        label.textAlignment = .center
        label.text = floatTimeToDateString(since1970: self.dream.date)
        label.numberOfLines = 1
        return label
    }()
    
    lazy var textLabel : UILabel = {
        let label = UILabel(frame: .init(x: 10, y: dateLabel.frame.maxY + 20, width: self.view.frame.size.width, height: 100))
        label.font = UIFont(name: "Rubik-Regular", size: 22)
        label.textColor = .white
        label.textAlignment = .left
        label.text = self.dream.text
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(hex: "#18686Fff")
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(textLabel)
        self.scrollView.addSubview(dateLabel)
        
        // Scroll View constraints
        self.scrollView.leadingAnchor
            .constraint(equalTo: self.view.leadingAnchor, constant: 20)
            .isActive = true;
        self.scrollView.topAnchor
            .constraint(equalTo: self.view.topAnchor, constant: 20)
            .isActive = true;
        self.scrollView.trailingAnchor
            .constraint(equalTo: self.view.trailingAnchor, constant: -20)
            .isActive = true;
        self.scrollView.bottomAnchor
            .constraint(equalTo: self.view.bottomAnchor, constant: -20)
            .isActive = true;
        
        // Title label constraints
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10),
            self.titleLabel.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 40),
            self.titleLabel.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            self.titleLabel.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
        ])
        
        // Text label
//        NSLayoutConstraint.activate([
//            self.textLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
//            self.textLabel.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor, constant: 10),
//            self.textLabel.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor, constant: -10),
//            self.textLabel.heightAnchor.constraint(equalToConstant: 300)
//        ])

    }
    
    
    init(dream : Dream){
        self.dream = dream
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
