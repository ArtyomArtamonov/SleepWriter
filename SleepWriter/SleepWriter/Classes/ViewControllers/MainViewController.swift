//
//  MainViewController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

protocol MainViewControllerDelegate : class {
    func setPage(index : Int) -> ()
}

class MainViewController: UIViewController {
    
    @IBOutlet private weak var pageControl: UIPageControl!
    
    @IBSegueAction private func embedSegue(_ coder: NSCoder) -> MainPageController? {
        let pageController = MainPageController(coder: coder)
        pageController?.rootDelegate = self
        return pageController
    }
    
    private func applyGradient() -> () {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 29/255, green: 168/255, blue: 183/255, alpha: 255/255).cgColor,
                                UIColor(hex: "#0A464BFF")!.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyGradient()
    }
}

extension MainViewController : MainViewControllerDelegate {
    internal func setPage(index: Int) -> () {
        self.pageControl.currentPage = index
    }
}
