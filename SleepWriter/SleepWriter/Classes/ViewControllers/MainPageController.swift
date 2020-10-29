//
//  MainPageController.swift
//  SleepWriter
//
//  Created by Tamerlan Satualdypov on 29.10.2020.
//  Copyright © 2020 Artyom Artamonov. All rights reserved.
//

import UIKit

class MainPageController : UIPageViewController {
    
    public weak var rootDelegate : MainViewControllerDelegate?
    
    private var pages : [UIViewController] = .init()
    
    private func configurePages() -> () {
        self.delegate = self
        self.dataSource = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let editVC = storyboard.instantiateViewController(identifier: "editDreamVC")
        let dreamsVC = storyboard.instantiateViewController(identifier: "dreamsVC")
        
        self.pages.append(editVC)
        self.pages.append(dreamsVC)
        
        self.setViewControllers([editVC], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configurePages()
    }
}

extension MainPageController : UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    internal func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                                     previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        // Берем первый элемент массива viewControllers, т.к.
        // там хранится текущий, презентуемый контроллер.
        guard let currentViewController = self.viewControllers?.first,
              let index = self.pages.firstIndex(of: currentViewController)
        else { return }
        
        self.rootDelegate?.setPage(index: index)
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        self.rootDelegate?.setPage(index: index - 1)
        return self.pages[index - 1]
    }
    
    internal func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = self.pages.firstIndex(of: viewController), index + 1 < self.pages.count else { return nil }
        self.rootDelegate?.setPage(index: index + 1)
        return self.pages[index + 1]
    }
}
