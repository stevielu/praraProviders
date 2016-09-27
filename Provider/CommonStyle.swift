//
//  CommonStyle.swift
//  Provider
//
//  Created by imac on 2/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import UIKit

class globalStyle {
    //width & height
    static var screenSize: CGRect = UIScreen.mainScreen().bounds
    static let start = screenSize.width/3

    //font
    static let subTitleColor = UIColor(netHex:0x666666)
    static let subTitleColor2 = UIColor(netHex:0x999999)
    static let subTitleColor3 = UIColor(netHex:0xdf896d)
    static let subTitleColor4 = UIColor(netHex:0xbfbfbf)
    static let warningColor = UIColor(netHex:0xfee6e6)
    static let bgColor1 = UIColor(netHex:0xe6e6e6)
    static let nameTextColor = UIColor(netHex:0x4C4C4C)
    static let subTitleFontsize = UIFont(name:"Helvetica",size: 12.0)
    static let subTitleMediumFontsize = UIFont(name:"HelveticaNeue-Medium",size: 12.0)
    static let nameTitleFont = UIFont(name:"Helvetica",size: 15.0)
    static let titleFont = UIFont(name:"Helvetica",size: 13.0)
    static let dateTitleFont = UIFont(name:"Helvetica",size: 10.0)
    static let alertColor = UIColor(netHex:0xf25a5a)
    static let titleColor = UIColor(netHex:0x737373)
    //color
    static let backgroundColor = UIColor(netHex:0xdf6f6d)//FF5A5F da5a58
    static let backgroundColor2 = UIColor(netHex:0xda5a58)
    static let yellowColor = UIColor(netHex:0xF7C52E)
    static let greenColorS1 = UIColor(netHex: 0x35928E)
    static let greenColorS2 = UIColor(netHex: 0xA5BD78)
    static let chatIncomingColor = UIColor(netHex: 0xEFEFEF)
    static let chatOutgoingColor = UIColor(netHex: 0xFF4F55)
    static let deliverStatus = UIColor(netHex: 0xE71E37)
    //thickness
    static let thickness:CGFloat = 0.5
    
    //image size
    static let avatarSize =  CGSize(width: 50, height: 50)
    static let myProfileSize =  CGSize(width: 100, height: 100)
    static let arrowSize =  CGSize(width: 25, height: 25)
    static let imageCompressMaxSize = 300
}
