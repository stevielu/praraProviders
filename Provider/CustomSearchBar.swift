//
//  CustomSearchBar.swift
//  Provider
//
//  Created by imac on 3/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    
    var preferredFont: UIFont!
    var preferredTextColor: UIColor!
    var preferredHeight: CGFloat!
    //var preferredWidth: CGFloat!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Drawing code
        
        // Find the index of the search field in the search bar subviews.
        if let textindex = indexOfSearchFieldInSubviews(UITextField) {
            // Access the search field
            let searchField: UITextField = (subviews[0] ).subviews[textindex] as! UITextField
            
            // Set its frame.
            //searchField.frame = CGRectMake(5.0, 5.0, frame.size.width - 10.0, frame.size.height - 10.0)
            
            // Set the font and text color of the search field.
            searchField.font = preferredFont
            searchField.textColor = preferredTextColor
            searchField.frame.size.height = preferredHeight
            //searchField.frame.size.width = preferredWidth
            searchField.layer.cornerRadius = 12.0
            // Set the background color of the search field.
            //searchField.backgroundColor = barTintColor
        }
        if let cancelBtnindex = indexOfSearchFieldInSubviews(UIButton){
            let cancelBTN: UIButton = (subviews[0] ).subviews[cancelBtnindex] as! UIButton
            
            cancelBTN.tintColor = UIColor.whiteColor()
        }
        
        
        //        let startPoint = CGPointMake(0.0, frame.size.height)
        //        let endPoint = CGPointMake(frame.size.width, frame.size.height)
        //        let path = UIBezierPath()
        //        path.moveToPoint(startPoint)
        //        path.addLineToPoint(endPoint)
        //
        //        let shapeLayer = CAShapeLayer()
        //        shapeLayer.path = path.CGPath
        //        shapeLayer.strokeColor = preferredTextColor.CGColor
        //        shapeLayer.lineWidth = 2.5
        
        //        layer.addSublayer(shapeLayer)
        
        //super.drawRect(rect)
    }
    
    
    init(frame: CGRect, font: UIFont, textColor: UIColor,barHeight:CGFloat) {
        super.init(frame: frame)
        
        self.frame = frame
        preferredFont = font
        preferredTextColor = textColor
        preferredHeight = barHeight
        //preferredWidth = barWidth
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func indexOfSearchFieldInSubviews(type:AnyClass) -> Int! {
        var index:Int!
        let searchBarView = subviews[0]
        
        for i in 0 ..< searchBarView.subviews.count {
            if searchBarView.subviews[i].isKindOfClass(type){
                index = i
                break
            }
        }
        
        return index
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
}
