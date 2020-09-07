//
//  GradientViewController.swift
//  SleepWriter
//
//  Created by Artyom Artamonov on 07.09.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class GradientViewController: UIViewController {
    
    var gradientLayer : CAGradientLayer!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        
        gradientLayer.colors = [UIColor(red: 20/255, green: 153/255, blue: 166/255, alpha: 158.1/255).cgColor, UIColor(hex: "#0A464BFF")!.cgColor]
        
        self.view.layer.addSublayer(gradientLayer)
    }

}
