//
//  CustomNavgationbarItemsViewController.swift
//  Provider
//
//  Created by imac on 2/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class CustomNavgationbarItemsViewController: UIViewController {
    
    let homeBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        createHomeButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createHomeButton(){
        
        homeBtn.setImage(UIImage(named: "HomeBtn.png"), forState: .Normal)
        //add function for button
        homeBtn.addTarget(self, action: #selector(self.homeButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        
        //set frame
        homeBtn.frame = CGRect(x: 12.5, y: 12.5, width: 25, height: 25)
        
        
        let barButton = UIBarButtonItem(customView: homeBtn)
        self.navigationItem.leftBarButtonItem = barButton
        self.navigationController?.navigationBar.translucent = false;
        
        

    }
    
    func homeButtonPressed()  {
        
    }

    
//    func createSearchBar()  {
//        searchBar.setShowsCancelButton(true, animated: true)
//        searchBar.tintColor = UIColor.whiteColor()
//        
//        let cancelBtn = searchBar.valueForKey("cancelButton") as! UIButton
//        cancelBtn.animateWithDuration
//
//        searchBar.placeholder = "Typle in any key words"
//        searchBar.delegate = self
//        self.navigationItem.titleView = searchBar
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetHeight(self.frame), thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, UIScreen.mainScreen().bounds.width, thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
    
}
