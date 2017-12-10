//
//  LeaderboardPageViewController.swift
//  Jumbyrinth
//
//  Created by Aiwen Xu on 06/12/2017.
//  Copyright © 2017 nyu.edu. All rights reserved.
//

import UIKit

// The view controller that organizes the leaderboard for each level into a collection of pages.
class LeaderboardPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // The page indicator at the bottom of the view.
    var pageControl = UIPageControl()
    
    // An array of the view controller for each page.
    lazy var orderedViewControllers: [UIViewController] = {
        return [self.newVc(viewController: "level1"),
                self.newVc(viewController: "level2"),
                self.newVc(viewController: "level3"),
                self.newVc(viewController: "level4"),
                self.newVc(viewController: "level5"),
                self.newVc(viewController: "level6")]
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self

        // Sets up the first view.
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        
        // Display the page indicator.
        configurePageControl()
    
    }
    
    func configurePageControl() {
        // Set the frame size of the page control.
        pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.maxY - 50, width: UIScreen.main.bounds.width, height: 50))
        // The total number of pages available is the total number of the view controllers.
        self.pageControl.numberOfPages = orderedViewControllers.count
        // Set the current page to the first page.
        self.pageControl.currentPage = 0
        // Set the color of the page control.
        self.pageControl.tintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        // Add page control to the view.
        self.view.addSubview(pageControl)
    }
    
    // Instantiate a new view controller to display.
    func newVc(viewController: String) -> LeaderboardTableViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewController) as! LeaderboardTableViewController
    }

    // Delegate function.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = orderedViewControllers.index(of: pageContentViewController)!
    }
    
    // Data source functions.
    // Get the previous view controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Get the index of the current view controller.
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        // The previous index is the current index minus 1.
        let previousIndex = viewControllerIndex - 1
        
        // Swiping left on the first view controller loops to the last view controller.
        guard previousIndex >= 0 else {
            return orderedViewControllers.last
        }
        
        // If the previous index exceeds the total number of view controllers, return nil.
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        // Returns the previous view controller.
        return orderedViewControllers[previousIndex]
        
    }
    
    // Get the next view controller.
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Get the index of the current view controller.
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        // The next index is the current index plus 1.
        let nextIndex = viewControllerIndex + 1
        
        // The total numbers of view controllers.
        let orderedViewControllersCount = orderedViewControllers.count
        
        // Swiping right on the last view controller loops to the first view controller.
        guard orderedViewControllersCount != nextIndex else {
            return orderedViewControllers.first
        }
        
        // If the next index exceeds the total number of view controllers, return nil.
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        // Returns the next view controller.
        return orderedViewControllers[nextIndex]
        
    }
    
}
