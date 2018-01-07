//
//  TutorialPageViewController.swift
//  TileBreaker
//
//  Created by GGR on 1/7/18.
//  Copyright © 2018 ggr. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    lazy var orderedViewControllers: [UIViewController] = {
        let timed = storyboard?.instantiateViewController(withIdentifier: "TimedModeTutorialController")
        
        let moves = storyboard?.instantiateViewController(withIdentifier: "MovesModeTutorialController")
        
        return [timed!, moves!]
    }()
    
    private func ViewInstance (name: String) -> UIViewController
    {
        let viewInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
        
        return viewInstance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        if let InfoPage = orderedViewControllers.first {
            setViewControllers([InfoPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
                return nil
        }
        
        if (viewControllerIndex < 1) {
            return nil
        }
        
        return orderedViewControllers[viewControllerIndex - 1]
    }
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController)
            else {
                return nil
        }
        
        if viewControllerIndex == orderedViewControllers.count-1 {
            return nil
        }
        
        return orderedViewControllers[viewControllerIndex + 1]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController)
            else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
