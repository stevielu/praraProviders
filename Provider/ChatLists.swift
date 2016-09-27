//
//  ChatLists.swift
//  Provider
//
//  Created by imac on 12/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import RealmSwift
import Foundation
class tb_c2cTables: Object {
    dynamic var myEmail = ""
    dynamic var senderEmail = ""
    dynamic var latestedMsg = ""
    dynamic var latestedMsgType = ""
    dynamic var userFirstName  = ""
    dynamic var userLastName  = ""
    dynamic var userProfile  = ""
    dynamic var unreadMsg = 0
    dynamic var createdDate = NSDate()
    let chatRecords = List<tb_c2cMsg_Content>()
}
