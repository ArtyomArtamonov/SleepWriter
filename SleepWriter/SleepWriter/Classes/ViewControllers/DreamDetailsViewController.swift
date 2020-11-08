//
//  DreamDetailsViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 05.11.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamDetailsViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var contentView: UIView!
    
    private var dream : Dream!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = dream.title
        textLabel.text = dream.text
        
    }
    
    public func set(_ dream : Dream){
        self.dream = dream
    }
    
    

}
