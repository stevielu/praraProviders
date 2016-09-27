//
//  ChatAPI.swift
//  Provider
//
//  Created by imac on 6/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftR
import SwiftyJSON
import Alamofire

class SignalRChat {
    let connectBaseUrl = "http://para.co.nz/api/ChatProvider/Connect"
    let sendTextMessageBaseUrl = "http://para.co.nz/api/ChatProvider/SendTextMessage"
    var connectionID = ""
    var myName = ""
    func registerConnection(connectionID:String){
        let myName = NSUserDefaults.standardUserDefaults()
        
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        Alamofire.request(.POST, self.connectBaseUrl,parameters: ["Username":self.myName,"ConnectionId": connectionID]).validate().responseJSON{response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                print(json)
                if(json == true){
                                   }
                else if (json == false){
                    
                }
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
           
        }
    }
    
    func sendMessage(text:String,senderEmail:String,completion: (data:JSON?)->Void){
        
        //print(self.connectionID)
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        let url = NSURL(string: sendTextMessageBaseUrl)
        let request = NSMutableURLRequest(URL: url!)
        let values = ["FromUsername":self.myName, "MessageContent":text, "ToUsername": senderEmail]
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(values, options: [])

        
        Alamofire.request(request).validate().responseJSON{response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                print(json)
                if(json == true){
                    //self.saveChatRecords(<#T##ChatMsg#>, unreadMsg: 0, type: "Text")
                    
                }
                else if (json == false){
                   
                }
                 completion(data: json)
            case .Failure(let error):
                print("Request failed with error: \(error)")
                 completion(data: JSON(error))
            }
            
        }
        
        
    }
    
    func sendMedia(Image media:NSData,senderEmail:String){
        
        //print(self.connectionID)
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        let url = NSURL(string: "http://para.co.nz/api/ChatProvider/SendImageMessage/"+self.myName+"/"+senderEmail)
        //let imageData = UIImagePNGRepresentation(media)
        Alamofire.upload(.POST,
                         url!,
                         headers: ["Authorization" : "Basic xxx"],
                         multipartFormData:{data in
            data.appendBodyPart(data: media, name: "chatImage", fileName: "chatImage", mimeType: "image/*")
        },
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                print("s")
                upload.responseJSON {
                    response in
                    print(response.request)  // original URL request
                    print(response.response) // URL response
                    print(response.data)     // server data
                    print(response.result)   // result of response serialization
                    
                    if let JSON = response.result.value {
                        print("JSON: \(JSON)")
                    }
                }
            case .Failure(let encodingError):
                print(encodingError)
            }
        }
        )
    }
    
    func getUnreads(sernderEmail:String) -> Int {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",sernderEmail,self.myName)
        if let results:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate){
            if(results.first?.unreadMsg != nil){
                return (results.first?.unreadMsg)!
            }
            else{ return 0 }
        }
        else{ return 0 }
    }
    
    func getAllUnreads() -> Int {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        var subUnreads = 0
        if let results:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter("myEmail = %@",self.myName){
            for value in results {
                subUnreads = subUnreads + value.unreadMsg
            }
        }
        else{
            subUnreads = 0
        }
        return subUnreads
    }
    
    func clearUnreads(sernderEmail:String) -> Bool{
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        guard let realm = try? Realm() else { return false}
        let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",sernderEmail,self.myName)
        if let results:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate){
            try! realm.write {
                results.first?.unreadMsg = 0
            }
            
            return true
        }
        return false
    }
    
    func checkRecordExist(sernderEmail:String) -> Bool {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",sernderEmail,self.myName)
        print(self.myName)
        let results = uiRealm.objects(tb_c2cTables).filter(predicate)
        if(results.count != 0){return true}
        else{ return false}
    }
    
//    func reorderC2CLists(newObject:tb_c2cTables) -> Bool{
//        guard let realm = try? Realm() else { return false}
//        
//        if let results:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables){
//            try! realm.write {
//                
//            }
//            return true
//        }
//        else{
//            return false
//        }
//        
//    }
    func getLastID(senderEmail:String) -> Int {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        if(self.checkRecordExist(senderEmail)){
        let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",senderEmail,self.myName)
        let user:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate)
        let contentObjc = user.first?.chatRecords
        //let contentObjc:Results<tb_c2cMsg_Content> = uiRealm.objects(tb_c2cMsg_Content)
        let lastId = contentObjc!.last!.contentID
        return lastId
        }
        else{
        return -1
        }
    }
    
    func saveChatRecords(data:ChatMsg,unreadMsg unread:Int,type contentType:String,IamSender iAmSender:Bool) -> Bool {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        guard let realm = try? Realm() else { return false}
        
        if(self.checkRecordExist(data.senderEmail)){
            //let contentObjc:Results<tb_c2cMsg_Content> = realm.objects(tb_c2cMsg_Content)
            //contentObjc.last!.contentID
            let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",data.senderEmail,self.myName)
            let user:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate)
            
            try! realm.write {
                let contents = tb_c2cMsg_Content()
                let lastId = getLastID(data.senderEmail)
                user.first?.latestedMsg = data.content
                user.first?.latestedMsgType = contentType
                user.first?.unreadMsg = unread
                user.first?.createdDate = data.createdDate
                user.first?.userProfile = data.profile
                
                if(iAmSender){
                    contents.senderEmail = self.myName
                }
                else{
                    contents.senderEmail = data.senderEmail
                }
                contents.content = data.content
                contents.createdDate = data.createdDate
                
                //set pageID
                let pageCount = user.first?.chatRecords.filter("contentID = %@",lastId)
                if(pageCount!.count >= 10){
                    contents.contentID = lastId + 1
                }
                else{
                    contents.contentID = lastId
                }
                
                contents.contentType = contentType
                contents.messageStatus = data.msgStatus
                
                let mediaObj = tb_c2cPicURL()
                mediaObj.owner =  contents
                if(contentType == "pic"){
                    mediaObj.createdDate = data.createdDate
                    mediaObj.originalURL = data.picURL
                }
                user.first?.chatRecords.append(contents)
            }
        }
        else{//first touch
            let newUser = tb_c2cTables()
            let newContent = tb_c2cMsg_Content()
            try! realm.write {
                newUser.senderEmail = data.senderEmail
                newUser.createdDate = data.createdDate
                newUser.unreadMsg = unread
                newUser.latestedMsg = data.content
                newUser.latestedMsgType = contentType
                newUser.userFirstName = data.firstName
                newUser.userLastName = data.lastName
                newUser.userProfile = data.profile
                newUser.myEmail = self.myName
                
                if(iAmSender){
                    newContent.senderEmail = self.myName
                }
                else{
                    newContent.senderEmail = data.senderEmail
                }
                //newContent.senderEmail = data.senderEmail
                newContent.content = data.content
                newContent.createdDate = data.createdDate
                newContent.contentID = 1
                newContent.contentType = contentType
                newContent.messageStatus = data.msgStatus
                let mediaObj = tb_c2cPicURL()
                mediaObj.owner =  newContent
                if(contentType == "pic"){
                    mediaObj.createdDate = data.createdDate
                    mediaObj.originalURL = data.picURL
                }
                
                realm.add(newUser)
                newUser.chatRecords.append(newContent)
                
            }
        }
        return true
    }
    
    func fetchChatLists(userName:String)-> [tb_c2cTables]? {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
            let predicate = NSPredicate(format: "myEmail = %@",userName)
            if var c2cLists:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate){
                c2cLists = c2cLists.sorted("createdDate", ascending: false)
                return Array(c2cLists)
            }
            return nil
    }
    
    func fetchRecords(recordsName:String)-> [tb_c2cMsg_Content]? {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        if(self.checkRecordExist(recordsName) == true){
            let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",recordsName,self.myName)
            let c2cLists:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate)
            let c2cContents:List<tb_c2cMsg_Content> = (c2cLists.first?.chatRecords)!
            return Array(c2cContents)
        }
        else{
            return nil
        }
        
    }
    func fetchRecordsWithPageID(recordsName:String,pageID:Int)-> [tb_c2cMsg_Content]? {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        if(self.checkRecordExist(recordsName) == true){
            let predicate = NSPredicate(format: "senderEmail = %@ AND myEmail = %@",recordsName,self.myName)
            let c2cLists:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate)
            let c2cContents:Results<tb_c2cMsg_Content> = (c2cLists.first?.chatRecords.filter("contentID = %@",pageID))!
            return Array(c2cContents)
        }
        else{
            return nil
        }
        
    }
    
    func deleteRecord(recordName:String) -> Bool {
        let myName = NSUserDefaults.standardUserDefaults()
        self.myName = myName.objectForKey("ActiveUser") as! String
        
        guard let realm = try? Realm() else { return false}
        if(self.checkRecordExist(recordName) == true){
            let table:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter("senderEmail = %@ AND myEmail = %@",recordName,self.myName)
            try! realm.write {
                realm.delete(table.first!)
            }
            return true
        }
        else{
            return false
        }
    }
//    func updateUnreads(updateObject:String)-> Bool {
//        guard let realm = try? Realm() else { return false}
//        let predicate = NSPredicate(format: "senderEmail = %@",updateObject)
//        let results:Results<tb_c2cTables> = uiRealm.objects(tb_c2cTables).filter(predicate)
//        if(results.first?.unreadMsg != nil){
//            try! realm.write {
//                results.first?.unreadMsg = 0
//            }
//        }
//        return Array(c2cLists)
//    }
    
    
}
