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
        
        // set up view header label
        let label = UILabel(frame: CGRectMake(0, 0, view.frame.width, 200))
        label.textColor = UIColor.whiteColor()
        label.text = titleText
        label.textAlignment = .Center
        view.addSubview(label)
        
        // get date using page index. this is used to get images
        getDate(pageIndex)
        
        // get images by date. these will be displayed on the view.
        getImages(startDate, endDate: endDate)
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
        
        //create view images display on
        let imageView = UIImageView(frame: CGRectMake(0, 200, view.frame.width, 200))
        
        
        // prep photo manager w/ fetch options. get images as PHAssets
        let photoManager: PHImageManager = PHImageManager.defaultManager()
        let fetchOptions: PHFetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ && creationDate <= %@", startDate, endDate)
        let images = PHAsset.fetchAssetsWithMediaType(.Image, options: fetchOptions)
        // trying to load image into memory. must fix this
        // read documents. just get meta data without getting image itself
        println("START DATE \(startDate)")
        println("END DATE \(endDate)")
        println("IMAGE COUNT\(images.count)")
        //println(fetchOptions)
        // if you get images loop through image assets to get image. attach to imageView.
        if (images.count>=1){
            for x in 0...images.count-1 {
                photoManager.requestImageForAsset(images[x] as PHAsset,
                    targetSize: PHImageManagerMaximumSize,
                    contentMode: .AspectFit, options: nil) {
                        image, info in
                        imageView.image = image
                    }
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
