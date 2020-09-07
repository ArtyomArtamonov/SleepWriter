//
//  DreamsViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 06.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamsViewController: GradientViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        label.text = "second window"
        label.textColor = .black
        
        self.view.addSubview(label)
    }

}
