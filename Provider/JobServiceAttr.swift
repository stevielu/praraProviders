//
//  JobServiceAttr.swift
//  Provider
//
//  Created by imac on 17/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import SwiftyJSON
@objc(JobServiceAttr)

class JobServiceAttr: NSObject, NSCoding{
    var createDate :NSDate?
    var clientId:NSNumber?
    var dueDate:String?
    var jobSuburb:String?
    var clientName:String?
    var title:String?
    var profilePhoto:String?
    var id:NSNumber?
    var descript:String?
    var status:NSNumber?
    var servicePhotoUrl:[String]?
    var addressDetail:String?
    var cellPhone:String?
    var homePhone:String?
    var clientEmail:String?
    var budget:Float?
    var type:String?
    
    
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let createDate = self.createDate {
            aCoder.encodeObject(createDate, forKey: "createDate")
        }
        if let clientId = self.clientId {
            aCoder.encodeObject(clientId, forKey: "clientId")
        }
        if let dueDate = self.dueDate {
            aCoder.encodeObject(dueDate, forKey: "dueDate")
        }
        if let jobSuburb = self.jobSuburb {
            aCoder.encodeObject(jobSuburb, forKey: "jobSuburb")
        }
        if let clientName = self.clientName {
            aCoder.encodeObject(clientName, forKey: "clientName")
        }
        
        if let title = self.title {
            aCoder.encodeObject(title, forKey: "title")
        }
        if let profilePhoto = self.profilePhoto {
            aCoder.encodeObject(profilePhoto, forKey: "profilePhoto")
        }
        if let id = self.id {
            aCoder.encodeObject(id, forKey: "id")
        }
        if let descript = self.descript {
            aCoder.encodeObject(descript, forKey: "descript")
        }
        if let status = self.status {
            aCoder.encodeObject(status, forKey: "status")
        }
        if let servicePhotoUrl = self.servicePhotoUrl {
            aCoder.encodeObject(servicePhotoUrl, forKey: "servicePhotoUrl")
        }
        if let addressDetail = self.addressDetail {
            aCoder.encodeObject(addressDetail, forKey: "addressDetail")
        }
        if let cellPhone = self.cellPhone {
            aCoder.encodeObject(cellPhone, forKey: "cellPhone")
        }
        if let homePhone = self.homePhone {
            aCoder.encodeObject(homePhone, forKey: "homePhone")
        }
        if let clientEmail = self.clientEmail {
            aCoder.encodeObject(clientEmail, forKey: "clientEmail")
        }
        if let budget = self.budget {
            aCoder.encodeObject(budget, forKey: "budget")
        }
        if let type = self.type {
            aCoder.encodeObject(type, forKey: "type")
        }
        
        
        
        
    }
    
    override init() {
    }
    
    func JSONDataPhrase(data:JSON){
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        createDate = formatter.dateFromString(data["CreatedDate"].stringValue)
        clientId = data["ClientId"].intValue
        dueDate = data["DueDate"].stringValue
        jobSuburb = data["JobSuburb"].stringValue
        clientName = data["ClientName"].stringValue
        title = data["Title"].stringValue
        profilePhoto = data["ProfilePhoto"].stringValue
        id = data["Id"].intValue
        descript = data["Description"].stringValue
        status = data["Status"].intValue
        servicePhotoUrl = data["ServicePhotoUrl"].arrayObject as? [String]
        addressDetail = data["AddressDetail"].stringValue
        cellPhone = data["CellPhone"].stringValue
        homePhone = data["HomePhone"].stringValue
        clientEmail = data["ClientEmail"].stringValue
        budget = data["Budget"].floatValue
        type = data["Type"].stringValue
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        self.createDate = aDecoder.decodeObjectForKey("createDate") as? NSDate
        
        self.clientId = aDecoder.decodeObjectForKey("clientId") as? NSNumber
        
        
        self.dueDate = aDecoder.decodeObjectForKey( "dueDate") as? String
        
        
        self.jobSuburb = aDecoder.decodeObjectForKey("jobSuburb") as? String
        
        
        self.clientName = aDecoder.decodeObjectForKey("clientName") as? String
        
        
        self.title = aDecoder.decodeObjectForKey("title") as? String
        
        
        self.profilePhoto = aDecoder.decodeObjectForKey("profilePhoto") as? String
        
        
        self.id = aDecoder.decodeObjectForKey("id") as? NSNumber
        
        
        self.descript = aDecoder.decodeObjectForKey("descript") as? String
        
        
        self.status = aDecoder.decodeObjectForKey("status") as? NSNumber
        
        
        self.servicePhotoUrl = aDecoder.decodeObjectForKey("servicePhotoUrl") as? [String]
        
        
        self.addressDetail = aDecoder.decodeObjectForKey("addressDetail") as? String
        
        
        self.cellPhone = aDecoder.decodeObjectForKey("cellPhone") as? String
        
        
        self.homePhone = aDecoder.decodeObjectForKey("homePhone") as? String
        
        
        self.clientEmail = aDecoder.decodeObjectForKey("clientEmail") as? String
        
        
        self.budget = aDecoder.decodeObjectForKey("budget") as? Float
        
        
        self.type = aDecoder.decodeObjectForKey("type") as? String
        
        
    }
    
}
