//
//  ServiceDataProcess.swift
//  Provider
//
//  Created by imac on 16/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import Foundation
import Alamofire

import SwiftyJSON
import Kingfisher

class ServiceDataProcess{
    
    func dataPost(requestUrl: String) {
        Alamofire.request(.POST, requestUrl).validate().responseJSON{response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                // let name = json["name"].stringValue
                print(json)
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func JSONDataGet(requestUrl: String,LookUpforClassbyKey className:String,pushAction pushAct:Bool,completion: (AnyObject)->Void) {
        Alamofire.request(.GET, requestUrl).validate().responseJSON{ response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                //let infoCache: Cache = Cache.shareInstance
                //let diskcache = DiskCache.shareInstance
                
                //save and phrase data
                switch className{
                case "JobServiceAttr":
                    var infoArray = [JobServiceAttr]()
                    //var outLimted = false
                    //var infoCacheArray = [JobServiceAttr]()
                    //save to cache
                    for value in json.array! {
                        //info[index].JSONDataPhrase(value)
                        let newjob = JobServiceAttr()
                        newjob.JSONDataPhrase(value)
                        infoArray.append(newjob)
//                        if(index > maxCount && outLimted == false){
//                            outLimted = true
//                            infoCacheArray = infoArray
//                        }
                    }
                    
                    if(pushAct==false){
                        let serviceData = NSKeyedArchiver.archivedDataWithRootObject(infoArray)
                    
                        let lists = NSUserDefaults.standardUserDefaults()
                        lists.removeObjectForKey("ServiceList")
                        lists.setObject(serviceData, forKey: "ServiceList")
                        lists.synchronize()
                    }
                    completion(infoArray)
                    
                    break
                case "ClientProfile":
                    let clientInfo:ClientProfile = ClientProfile(JSONData: json)
                    completion(clientInfo)
                    break
                    
                case "FetchImagefile":
                    completion(data)
                    break
                    
                default:
                    completion(data)
                    break
                }
                
                
                
            case .Failure(let error):
                completion("Fail")
                print("Request failed with error: \(error)")
                
            }
        }
    }

    internal func checkServerDataExistInCache(keyword:String) -> AnyObject{
        
        let lists = NSUserDefaults.standardUserDefaults()
        if let archivedData = lists.objectForKey(keyword) as? NSData{
            return archivedData
        }
        return false
    }
    
//    internal func checkServerDataExistInDisk(keyword:String) -> AnyObject{
//        let disk:DiskCache = DiskCache.shareInstance
//        if let archivedData = disk.object(forKey: keyword) as? NSData {
//            return archivedData
//        }
//        return false
//    }
    
    
    func retrieveCellImg(ImgURL:String,image:UIImageView,completion:(data:AnyObject?)->Void){
        let URL = NSURL(string: ImgURL)!
        image.kf_setImageWithURL(URL, placeholderImage: UIImage(named: "default.png"),
                                              optionsInfo: [.Transition(ImageTransition.Fade(1))],
                                              progressBlock: { receivedSize, totalSize in
                                                //print("\(indexPath.row + 1): \(receivedSize)/\(totalSize)")
            },
                                              completionHandler: { image, error, cacheType, imageURL in
                                                print("\(imageURL): Finished")
                                                completion(data: error)
        })
        
    }
    
    func fetchFBProfile(completion:(data:AnyObject?)->Void){
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).startWithCompletionHandler{(connection,result,error) -> Void in
            if error == nil {
                print(result)
                completion(data: result)
            }
            else{
                completion(data: error)
            }
            
        }
    }
    
}
