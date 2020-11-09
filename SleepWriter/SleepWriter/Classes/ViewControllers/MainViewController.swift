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
    func showDetails(of dream : Dream) -> ()
}

class MainViewController: UIViewController {
    
    @IBOutlet private weak var pageControl: UIPageControl!
    
    @IBSegueAction private func embedSegue(_ coder: NSCoder) -> MainPageController? {
        let pageController = MainPageController(coder: coder)
        pageController?.rootDelegate = self
        pageController?.configurePages()
        #warning("TODO: Think about adding initializer with configurePages() call in it")
        return pageController
    }
    
    var dreamToShowDetailsOf : Dream?
    
    private func applyGradient() -> () {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor(red: 29/255, green: 168/255, blue: 183/255, alpha: 255/255).cgColor,
                                UIColor(hex: "#0A464BFF")!.cgColor]
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dreamDetails" {
             guard let VC = segue.destination as? DreamDetailsViewController else { return }
            guard let dream = self.dreamToShowDetailsOf else { return }
            VC.set(dream)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.applyGradient()
    }
}

extension MainViewController : MainViewControllerDelegate {
    
    func showDetails(of dream: Dream) {
        print("Show details start")
        self.dreamToShowDetailsOf = dream
        performSegue(withIdentifier: "dreamDetails", sender: self)
        print("Show details end")
    }
    
    internal func setPage(index: Int) -> () {
        self.pageControl.currentPage = index
    }
}
