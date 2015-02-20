//
//  ViewController.swift
//  PhotoSearch
//
//  Created by pat on 2/15/15.
//  Copyright (c) 2015 patspeiser. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["Three Months", "Six Months", "One Year"]
    //var pageImages : UIImage?
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: ImageViewViewController = viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // set up current, before, and after views
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index: Int = (viewController as ImageViewViewController).pageIndex
        println("BEFORE Start \(index)")
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--
        
        println("BEFORE End \(index)\n")
       return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index: Int = (viewController as ImageViewViewController).pageIndex
        println("After Start \(index)")
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }
        
        println("After End \(index)\n")
        return viewControllerAtIndex(index)
    }
    
    func viewControllerAtIndex(index: Int) -> ImageViewViewController?
    {
        println("Current Index Start \(index)")
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        // Create a new view controller and pass suitable data.
        currentIndex = index
        let pageContentViewController = ImageViewViewController()
        //pageContentViewController.getDate()
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.pageIndex = index
        
        
        println("Current Index End \(index)\n")
        return pageContentViewController
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}

