//
//  ChatHistory.swift
//  Provider
//
//  Created by imac on 12/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import RealmSwift
import Foundation
class tb_c2cMsg_Content: Object {
    dynamic var senderEmail = ""
    dynamic var contentID = 0
    dynamic var content = ""
    dynamic var createdDate = NSDate()
    dynamic var contentType = ""
    dynamic var messageStatus = ""
}
