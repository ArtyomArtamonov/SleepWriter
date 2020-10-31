//
//  DreamCell.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class DreamCell : UITableViewCell {
    
    @IBOutlet private weak var mainView: UIView!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    
    public func display(title : String) -> () {
        self.titleLabel.text = title
    }
    
    public func display(date : String) -> () {
        self.dateLabel.text = date
    }
    
    override func awakeFromNib() -> () {
        super.awakeFromNib()
        self.mainView.layer.cornerRadius = 25
    }
}
