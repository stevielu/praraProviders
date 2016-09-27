//
//  PictureDetails.swift
//  Provider
//
//  Created by imac on 12/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import RealmSwift
import Foundation

class tb_c2cPicURL: Object {
    dynamic var originalURL = ""
    dynamic var thumbnail = ""
    dynamic var createdDate = NSDate()
    dynamic var owner:tb_c2cMsg_Content?
}
