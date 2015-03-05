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
    
    // check for not determined status on phauthorizationstatus
    
    var pageViewController : UIPageViewController?
    var pageTitles : Array<String> = ["Three Months Ago", "Six Months Ago", "One Year Ago"]
    var currentIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewdidload on viewcontroller")
        
        //createUserInterface()
        
        
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized {
        
            createUserInterface()
        
        } else {
            
           PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        
        }

    }
    func requestAuthorizationHandler(status: PHAuthorizationStatus)
    {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.Authorized
        {
            executeInMainQueue({ self.createUserInterface() })

        }
        else
        {
            executeInMainQueue({ self.dismissViewControllerAnimated(true, completion: nil) })
            let settingsPrompt = UIAlertController(title: "Authorization Required", message: "Enable access to photos?", preferredStyle: UIAlertControllerStyle.Alert)
            settingsPrompt.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
            settingsPrompt.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { alertAction -> Void in self.goToSettings() }))
            presentViewController(settingsPrompt, animated: true, completion: nil)
        }
    }
    
    func createUserInterface() {
        println("createuserinterface")
        pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
        pageViewController!.dataSource = self
        
        let startingViewController: ImageViewViewController = viewControllerAtIndex(0)!
        //let startingViewController: ImageViewViewController = 
        let viewControllers: NSArray = [startingViewController]
        pageViewController!.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: nil)
        pageViewController!.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
        
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
        pageViewController!.didMoveToParentViewController(self)
    }
    
    // set up current, before, and after views
    func viewControllerAtIndex(index: Int) -> ImageViewViewController?
    {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        // Create a new view controller and pass suitable data.
        currentIndex = index
        //let pageContentViewController = ImageViewViewController()
        
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageViewViewController") as ImageViewViewController
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.pageIndex = index
    
        return pageContentViewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        var index: Int = (viewController as ImageViewViewController).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index--

       return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        var index: Int = (viewController as ImageViewViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index++
        
        if (index == self.pageTitles.count) {
            return nil
        }

        return viewControllerAtIndex(index)
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return self.pageTitles.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
    
    func executeInMainQueue(function: () -> Void)
    {
        dispatch_async(dispatch_get_main_queue(), function)
    }
    
    func goToSettings() {
        UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

