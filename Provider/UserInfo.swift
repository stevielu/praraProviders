//
//  UserInfo.swift
//  Provider
//
//  Created by imac on 30/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import RealmSwift
import Foundation
class UserInfo: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
    dynamic var userName = ""
    dynamic var createdAt = NSDate()
    dynamic var lastName = ""
    dynamic var firstName = ""
    dynamic var phoneNumber = ""
    dynamic var workType = ""
    dynamic var skillDescription = ""
    dynamic var companyName = ""
    dynamic var street = ""
    dynamic var suburb = ""
    dynamic var city = ""
    dynamic var licenseNumber = ""
    dynamic var avatar = ""
    dynamic var myGallery = ""
}
