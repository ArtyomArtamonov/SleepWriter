//
//  DreamViewCell.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 11.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamTableViewCell: UITableViewCell {
    
    private let titleLabel : UILabel = {
        let label = UILabel()
        
        label.text = "title"
        label.font = UIFont(name: "Rubik-Bold", size: 21)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let mainTextLabel : UILabel = {
        let label = UILabel()
        
        label.text = ""
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont(name: "Rubik-Regular", size: 20)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let mainView : UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(hex: "#9EFF0020")
        view.layer.cornerRadius = 25
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    public func setCell(title: String, text: String){
        self.titleLabel.text = title
        self.mainTextLabel.text = text
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.addSubview(mainView)
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(mainTextLabel)
        
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            mainView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            mainView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            mainTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mainTextLabel.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
            mainTextLabel.widthAnchor.constraint(equalTo: mainView.widthAnchor),
            mainTextLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected{
            mainView.backgroundColor = UIColor(hex: "#9EFF0018")
        }
        else{
            mainView.backgroundColor = UIColor(hex: "#9EFF0020")
        }
    }

}
