//
//  ClientProfile.swift
//  Provider
//
//  Created by imac on 19/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation

import SwiftyJSON

class  ClientProfile{
    let Username : String
    let FirstName : String
    let LastName : String
    let ClientAddressCity : String
    let ClientAddressStreet : String
    let ClientAddressSuburb : String
    let ClientAddressId : Int
    let ProfilePicture : String
    let CellPhone : String
    

    init(JSONData data:JSON) {
        self.Username = data["Username"].stringValue
        self.FirstName = data["FirstName"].stringValue
        self.LastName = data["LastName"].stringValue
        self.ClientAddressCity = data["ClientAddressCity"].stringValue
        self.ClientAddressStreet = data["ClientAddressStreet"].stringValue
        self.ClientAddressSuburb = data["ClientAddressSuburb"].stringValue
        self.ClientAddressId = data["ClientAddressId"].intValue
        self.ProfilePicture = data["ProfilePicture"].stringValue
        self.CellPhone = data["CellPhone"].stringValue
    }
}