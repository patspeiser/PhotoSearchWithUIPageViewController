//
//  ImageViewViewController.swift
//  PhotoSearch
//
//  Created by pat on 2/16/15.
//  Copyright (c) 2015 patspeiser. All rights reserved.
//

// NOTE TO ME: Start looking into date ranges for image return. since there mare likely many days were a photo isn't taken.
//Look into displaying multiple pictures on the view instead of just one.

import UIKit
import Photos

class ImageViewViewController: UIViewController {
    
    //@IBOutlet weak var imageView: UIImageView!
    var titleText : String = ""
    let imageView: UIImageView!
    var pageIndex : Int!
    var startDate : NSDate!
    var endDate: NSDate!


    override func viewDidLoad() {
        super.viewDidLoad()
        //println("IMAGEVIEWVIEWCONTROLLER INDEX: \(pageIndex)")
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height
        println(statusBarHeight)
        // set up view header label
        let label = UILabel(frame: CGRectMake(0, statusBarHeight+25, view.frame.width, 25))
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.textColor = UIColor.whiteColor()
        label.text = titleText
        label.textAlignment = .Center
        
        
        // get date using page index. this is used to get images
        getDate(pageIndex)
        
        // get images by date. these will be displayed on the view.
        getImages(startDate, endDate: endDate)
        
        // add label overtop
        view.addSubview(label)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        println("APPEAR: \(self.pageIndex)");
    }
    
    // function to determine date
    
    func getDate(pageIndex: Int) -> (NSDate, NSDate) {
        //println("MADE IT TO getDate() FUNCTION!")
        
        switch pageIndex{
        case 0:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*80)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*90)
        case 1:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*170)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*190)
        case 2:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*355)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*375)
        default:
            startDate = NSDate()
            endDate = NSDate()
        }
        return (startDate, endDate)
    }

    // get images using Date. return view.
    func getImages(startDate: NSDate, endDate: NSDate) -> UIImageView {
        
        //create view images display on)
        let imageView = UIImageView(frame: CGRectMake(0, view.frame.maxY-(view.frame.width+100), view.frame.width, view.frame.width))
        //let imageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
        
        // prep photo manager w/ fetch options. get images as PHAssets
        let photoManager: PHImageManager = PHImageManager.defaultManager()
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "(creationDate >= %@) && (creationDate >= %@)", startDate, endDate)
        let images = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)

        // what to do when you get images. fetch image for asset and attach to imageview
        if (images.count>=1){
            
            //get high quality image
            let assetOptions = PHImageRequestOptions()
            assetOptions.deliveryMode = .HighQualityFormat
            
            photoManager.requestImageForAsset(images[0] as PHAsset,
                targetSize: PHImageManagerMaximumSize,
                contentMode: .AspectFill, options: nil) {
                    result, info in
                    println("P gI: Image gotten. Image Size: \(result?.size)")
                    //if result.size.width > 1000 && result.size.height > 1000 {
                    println(result)
                    imageView.image = result
                    
                    //}
                }
        } else {
            println("No images found.")
        }
        // return images and add the imageView to the main view.
        view.addSubview(imageView)
        return imageView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
