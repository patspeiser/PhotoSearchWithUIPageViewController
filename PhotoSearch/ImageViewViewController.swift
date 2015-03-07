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
import MessageUI
import MobileCoreServices

class ImageViewViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var textButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!

    var titleText : String!
    //let imageView: UIImageView!
    var pageIndex : Int!
    var startDate : NSDate!
    var endDate: NSDate!

    //move label to storyboard

    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewdidload on imageview")
        monthLabel.text = titleText
        
        //setUpUserInterface()
        
        // get date using page index. this is used to get images
        getDate(pageIndex)
        
        // get images by date. these will be displayed on the view.
        getImages(startDate, endDate: endDate)
        
        // add label overtop
        //view.addSubview(label)
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        println("APPEAR: \(self.pageIndex)\n");
    }
    
    // function to determine date
    
    func getDate(pageIndex: Int) -> (NSDate, NSDate) {
        //println("MADE IT TO getDate() FUNCTION!")
        
        switch pageIndex{
        case 0:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*89)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*91)
        case 1:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*179)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*181)
        case 2:
            startDate = NSDate().dateByAddingTimeInterval(-60*60*24*364)
            endDate = NSDate().dateByAddingTimeInterval(-60*60*24*366)
        default:
            startDate = NSDate()
            endDate = NSDate()
        }
        return (startDate, endDate)
    }

    // get images using Date. return view.
    
    func getImages(startDate: NSDate, endDate: NSDate) -> UIImageView {
        
        //property on UIImage view content mode
        //potentially change how image gets drawn in the view
        
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
                    self.imageView.image = result
                    
                    let originalImage = result
                    let targetWidth = self.imageView.frame.size.width
                    let targetHeight = self.imageView.frame.size.height
                    let originalWidth = originalImage?.size.width
                    let originalHeight = originalImage?.size.height
                    var adjustmentFactor = targetWidth / originalWidth!
                    if targetHeight / originalHeight! < adjustmentFactor {
                        
                        adjustmentFactor = targetHeight / originalHeight!
                        
                    }
                    
                    let adjustedHeight = originalHeight! * adjustmentFactor
                    let adjustedWidth = originalWidth! * adjustmentFactor
                    let adjustedSize = CGSizeMake(adjustedWidth, adjustedHeight)
                    
                    UIGraphicsBeginImageContext(adjustedSize)
                    originalImage?.drawInRect(CGRectMake(0,0,adjustedWidth, adjustedHeight))
                    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
                    
                    UIGraphicsEndImageContext()
                
                    self.imageView.image = newImage
                }
            
        } else {
            println("No images found.")
        }
        if imageView != nil {
            return imageView
        } else {
            imageView = UIImageView(frame: CGRectMake(0, 0, 0, 0))
            return imageView
        }
    }
    
    // need to get attachments working
    // remmeber that there are different kinds of image shtat can be used
    
    @IBAction func sendMessage(sender: AnyObject) {
        var messageVC = MFMessageComposeViewController()
       
        var imageToText = self.imageView.image
        var imageData = UIImageJPEGRepresentation(imageToText, 1.0)
        var fileName = self.imageView.image
        var fileType = kUTTypeJPEG
        
        messageVC.body = "Hey remember this?"
        messageVC.messageComposeDelegate = self
        //messageVC.addAttachmentData(imageToText, fileType, "fileName here?")
        messageVC.addAttachmentData(imageData, typeIdentifier: fileType, filename: "myAwesomeImage.jpeg")
        
        self.presentViewController(messageVC, animated: false, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        switch (result.value) {
        case MessageComposeResultCancelled.value:
            println("Message was cancelled")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.value:
            println("Message failed")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.value:
            println("Message was sent")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break;
        }
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
