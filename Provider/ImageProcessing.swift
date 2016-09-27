//
//  ImageProcessing.swift
//  Provider
//
//  Created by imac on 20/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import UIKit
import SKPhotoBrowser


private func configBrowser(){
    SKPhotoBrowserOptions.enableSingleTapDismiss = true
    SKPhotoBrowserOptions.disableVerticalSwipe = true
}

public func imageDisplayFullScreen(image:UIImage) -> SKPhotoBrowser{
        configBrowser()
    // do stuff with the image
        var images = [SKPhoto]()
        let photo = SKPhoto.photoWithImage(image)// add some UIImage
        images.append(photo)
    
    // 2. create PhotoBrowser Instance, and present from your viewController.
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(0)
    return browser
        
}

public func saveImage (image: NSData, path: String ) -> Bool{
    
//    let pngImageData = UIImagePNGRepresentation(image)
    //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
    let result = image.writeToFile(path, atomically: true)
    print(result)
    return result
    
    
}



// Get the documents Directory
public func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}
// Get path for a file in the directory
public func fileInDocumentsDirectory(filename: String) -> String {
    
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
    
}


func loadImageFromPath(path: String) -> UIImage? {
    
    let image = UIImage(contentsOfFile: path)
    
    if image == nil {
        
        print("missing image at: \(path)")
    }
    print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
    return image
    
}





//public func documentsDirectory() -> String {
//    let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] 
//    return documentsFolderPath
//}
//
//
//public func fileInDocumentsDirectory(filename: String) -> String {
//    return NSURL(fileURLWithPath: documentsDirectory()).URLByAppendingPathComponent(filename).absoluteString
//        //.URLByAppendingPathComponent(filename)//stringByAppendingPathComponent
//}

//public func loadImageFromPath(path: String) -> UIImage? {
//    
//    let image = UIImage(contentsOfFile: path)
//    
//    if image == nil {
//        
//        print("missing image at: (path)")
//    }
//    print("\(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
//    return image
//    
//}