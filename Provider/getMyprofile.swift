//
//  getMyprofile.swift
//  Provider
//
//  Created by imac on 27/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import RealmSwift


public func fetchProfileFromLocal() -> myAccount?{
    let userName = NSUserDefaults.standardUserDefaults().objectForKey("ActiveUser") as! String
    let results = uiRealm.objects(UserInfo).filter("userName = %@",userName)
    if let ret = results.first{
        let data = myAccount(
            myEmail: ret.userName,
            userFirstName: ret.firstName,
            userLastName: ret.lastName,
            userProfile: ret.avatar,
            ClientAddressCity: ret.city,
            ClientAddressStreet: ret.street,
            ClientAddressSuburb: ret.suburb,
            myPhone: ret.phoneNumber)
        return data
    }
    return nil
}