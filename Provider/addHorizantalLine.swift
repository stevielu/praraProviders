//
//  addHorizantalLine.swift
//  Provider
//
//  Created by imac on 25/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class addHorizantalLine: UIView {
    var start:CGPoint
    var end:CGPoint
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override func drawRect(rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.moveToPoint(start)
        
        aPath.addLineToPoint(end)
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.closePath()
        
        //If you want to stroke it with a red color
        UIColor.redColor().set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
    
    
    
    
    
    init(lineStart startCoordinates: CGPoint,lineEnd endCoordinates: CGPoint) {
        self.start = startCoordinates
        self.end = endCoordinates
        super.init(frame: CGRect(x: start.x, y: start.y, width: globalStyle.screenSize.width, height: 0.5))
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
