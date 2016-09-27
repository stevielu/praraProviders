//
//  help.swift
//  Provider
//
//  Created by imac on 2/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift
import SwiftyJSON
class help{
    
    static func associatedObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        initialiser: () -> ValueType)
        -> ValueType {
            if let associated = objc_getAssociatedObject(base, key)
                as? ValueType { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated,
                                     .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    
    static func associateObject<ValueType: AnyObject>(
        base: AnyObject,
        key: UnsafePointer<UInt8>,
        value: ValueType) {
        objc_setAssociatedObject(base, key, value,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
    
    static func reSizeImage(scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    static func differenceDate(lateDate date1:String,earlierDate date2:String) -> NSDateComponents{
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateLate = dateFormatter.dateFromString(date1)!
        let dateEarly = dateFormatter.dateFromString(date2)!
        
        let diffDateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: dateEarly, toDate: dateLate, options: NSCalendarOptions.init(rawValue: 0))
        
        return diffDateComponents
        
    }
    
    internal static let TransformWave = { (layer: CALayer) -> CATransform3D in
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, -layer.bounds.size.width/2.0, 0.0, 0.0)
        return transform
    }
    
    internal class func animateCell(cell: UITableViewCell, withTransform transform: (CALayer) -> CATransform3D, andDuration duration: NSTimeInterval) {
        
        let view = cell.contentView
        view.layer.transform = transform(cell.layer)
        view.layer.opacity = 0.8
        
        UIView.animateWithDuration(duration) {
            view.layer.transform = CATransform3DIdentity
            view.layer.opacity = 1
        }
    }
    
    static func alertLabelAnimator(target:UILabel) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(CGPoint: CGPointMake(target.center.x - 10, target.center.y))
        animation.toValue = NSValue(CGPoint: CGPointMake(target.center.x + 10, target.center.y))
        return animation
        
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    static func isValidPhoneNumber(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let phoneRegEx = "^\\d{7,}$"
        
        let phone = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phone.evaluateWithObject(testStr)
    }
    
    static func isValidLength(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let lenRegEx = "^.{0,50}$"
        
        let length = NSPredicate(format:"SELF MATCHES %@", lenRegEx)
        return length.evaluateWithObject(testStr)
    }
    
    static func isValidPassword(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let passRegEx = "^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"
        
        let pass = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        return pass.evaluateWithObject(testStr)
    }
    
    
    internal static func listeningNetworkStatus(reachability:Reachability){
        
        do {
            //Start Listening
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    static func resetSizeOfImageData(source_image: UIImage, maxSize: Int) -> NSData {
//        //先调整分辨率
//        var newSize = CGSize(width: source_image.size.width, height: source_image.size.height)
//        
//        let tempHeight = newSize.height / 1024
//        let tempWidth  = newSize.width / 1024
//        
//        if tempWidth > 1.0 && tempWidth > tempHeight {
//            newSize = CGSize(width: source_image.size.width / tempWidth, height: source_image.size.height / tempWidth)
//        }
//        else if tempHeight > 1.0 && tempWidth < tempHeight {
//            newSize = CGSize(width: source_image.size.width / tempHeight, height: source_image.size.height / tempHeight)
//        }
        // Reducing file size to a 10th
        
        var actualHeight : CGFloat = source_image.size.height
        var actualWidth : CGFloat = source_image.size.width
        let maxHeight : CGFloat = 1136.0
        let maxWidth : CGFloat = 640.0
        var imgRatio : CGFloat = actualWidth/actualHeight
        let maxRatio : CGFloat = maxWidth/maxHeight
        //var compressionQuality : CGFloat = 0.5
        
        if (actualHeight > maxHeight || actualWidth > maxWidth){
            if(imgRatio < maxRatio){
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight;
                actualWidth = imgRatio * actualWidth;
                actualHeight = maxHeight;
            }
            else if(imgRatio > maxRatio){
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth;
                actualHeight = imgRatio * actualHeight;
                actualWidth = maxWidth;
            }
            else{
                actualHeight = maxHeight;
                actualWidth = maxWidth;
                //compressionQuality = 1;
            }
        }
         let rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
        UIGraphicsBeginImageContext(rect.size);
        source_image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        //let newImage = UIImageJPEGRepresentation(img, compressionQuality);
        UIGraphicsEndImageContext();
        
//        UIGraphicsBeginImageContext(newSize)
//        source_image.drawAsPatternInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        //先判断当前质量是否满足要求，不满足再进行压缩
        var finallImageData = UIImageJPEGRepresentation(newImage,1.0)
        let sizeOrigin      = Int64((finallImageData?.length)!)
        let sizeOriginKB    = Int(sizeOrigin / 1024)
        if sizeOriginKB <= maxSize {
            return finallImageData!
        }
        
        //保存压缩系数
        let compressionQualityArr = NSMutableArray()
        let avg = CGFloat(1.0/250)
        var value = avg
        
        for var i = 250; i>=1; i-- {
            value = CGFloat(i)*avg
            compressionQualityArr.addObject(value)
        }
        
        //调整大小
        //说明：压缩系数数组compressionQualityArr是从大到小存储。
        //思路：折半计算，如果中间压缩系数仍然降不到目标值maxSize，则从后半部分开始寻找压缩系数；反之从前半部分寻找压缩系数
        finallImageData = UIImageJPEGRepresentation(newImage, CGFloat(compressionQualityArr[125] as! NSNumber))
        if Int(Int64((UIImageJPEGRepresentation(newImage, CGFloat(compressionQualityArr[125] as! NSNumber))?.length)!)/1024) > maxSize {
            //拿到最初的大小
            finallImageData = UIImageJPEGRepresentation(newImage, 1.0)
            //从后半部分开始
            for idx in 126..<250 {
                let value = compressionQualityArr[idx]
                let sizeOrigin   = Int64((finallImageData?.length)!)
                let sizeOriginKB = Int(sizeOrigin / 1024)
                print("当前降到的质量：\(sizeOriginKB)")
                if sizeOriginKB > maxSize {
                    print("\(idx)----\(value)")
                    finallImageData = UIImageJPEGRepresentation(newImage, CGFloat(value as! NSNumber))
                } else {
                    break
                }
            }
        } else {
            //拿到最初的大小
            finallImageData = UIImageJPEGRepresentation(newImage, 1.0)
            //从前半部分开始
            for idx in 0..<125 {
                let value = compressionQualityArr[idx]
                let sizeOrigin   = Int64((finallImageData?.length)!)
                let sizeOriginKB = Int(sizeOrigin / 1024)
                print("当前降到的质量：\(sizeOriginKB)")
                if sizeOriginKB > maxSize {
                    print("\(idx)----\(value)")
                    finallImageData = UIImageJPEGRepresentation(newImage, CGFloat(value as! NSNumber))
                } else {
                    break
                }
            }
        }
        return finallImageData!
    }
    static func jsonPackgePost(posturl:String,values:AnyObject) -> NSURLRequest{
        let url = NSURL(string: posturl)
        let request = NSMutableURLRequest(URL: url!)
        //let values = ["FromUsername":self.myName, "MessageContent":text, "ToUsername": senderEmail]
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(values, options: [])
        return request
    }

}
extension UIImage {
    //
    //    func RBSquareImageTo(size: CGSize) -> UIImage? {
    //        return self.RBSquareImage()?.RBResizeImage(size)
    //    }
    //
    //    func RBSquareImage() -> UIImage? {
    //        let originalWidth  = self.size.width
    //        let originalHeight = self.size.height
    //
    //        var edge: CGFloat
    //        if originalWidth > originalHeight {
    //            edge = originalHeight
    //        } else {
    //            edge = originalWidth
    //        }
    //
    //        let posX = (originalWidth  - edge) / 2.0
    //        let posY = (originalHeight - edge) / 2.0
    //
    //        let cropSquare = CGRectMake(posX, posY, edge, edge)
    //
    //        let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare);
    //        return UIImage(CGImage: imageRef!, scale: UIScreen.mainScreen().scale, orientation: self.imageOrientation)
    //    }
    //
    //    func RBResizeImage(targetSize: CGSize) -> UIImage {
    //        let size = self.size
    //
    //        let widthRatio  = targetSize.width  / self.size.width
    //        let heightRatio = targetSize.height / self.size.height
    //
    //        // Figure out what our orientation is, and use that to form the rectangle
    //        var newSize: CGSize
    //        if(widthRatio > heightRatio) {
    //            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
    //        } else {
    //            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
    //        }
    //
    //        // This is the rect that we've calculated out and this is what is actually used below
    //        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
    //
    //        // Actually do the resizing to the rect using the ImageContext stuff
    //        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.mainScreen().scale)
    //        self.drawInRect(rect)
    //        let newImage = UIGraphicsGetImageFromCurrentImageContext()
    //        UIGraphicsEndImageContext()
    //
    //        return newImage
    //    }
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.mainScreen().scale);
        self.drawInRect(CGRectMake(0, 0, reSize.width, reSize.height));
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    

}

