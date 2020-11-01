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
        
        self.isUserInteractionEnabled = true
        let interaction = UIContextMenuInteraction(delegate: self)
        self.addInteraction(interaction)
        
        self.mainView.layer.cornerRadius = 25
    }
}

extension DreamCell : UIContextMenuInteractionDelegate{
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
            let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
                let save = UIAction(title: "Delete", image: nil, identifier: nil) { action in
                        // Put button handler here
                        
                    }
                return UIMenu(title: "", image: nil, identifier: nil, options: .destructive, children: [save])
            }
            return configuration
        }
}

