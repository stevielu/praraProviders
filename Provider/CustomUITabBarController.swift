//
//  CustomUITabBarController.swift
//  Provider
//
//  Created by imac on 24/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import SwiftR
import SwiftyJSON

class CustomUITabBarController: UITabBarController {
    var chatHub: Hub?
    var allUnreads = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().barTintColor = globalStyle.backgroundColor
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        
        let chatNotificts = SignalRChat()
        let allUnreads = chatNotificts.getAllUnreads()


        
        
        
        let homeViewController = self.storyboard!.instantiateViewControllerWithIdentifier("homeView") as! HomeViewController
        let homeNavController = UINavigationController(rootViewController:homeViewController)
        
        homeViewController.sortViewContainer.backgroundColor = UIColor.whiteColor()
        homeNavController.tabBarItem.image = UIImage(named: "Main")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        homeNavController.tabBarItem.selectedImage = UIImage(named: "MainPressed")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        homeNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        

        let chatListViewController = self.storyboard!.instantiateViewControllerWithIdentifier("chatList") as! ChatListViewController
        let chatNavController = UINavigationController(rootViewController:chatListViewController)
        
        

        
        
        chatNavController.tabBarItem.image = UIImage(named: "Message")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        chatNavController.tabBarItem.selectedImage = UIImage(named: "MessagePressed")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        chatNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        let profileViewController = self.storyboard!.instantiateViewControllerWithIdentifier("myProfile") as! ProfileViewController
        let profileNavController = UINavigationController(rootViewController:profileViewController)
        
        profileNavController.tabBarItem.image = UIImage(named: "Profile")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        profileNavController.tabBarItem.selectedImage = UIImage(named: "ProfilePressed")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        profileNavController.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        
        
        if(allUnreads != 0){
            chatNavController.tabBarItem.badgeValue = String(allUnreads)
        }
        
        viewControllers = [homeNavController,chatNavController,profileNavController]
        
        

        //self.storyboard!.instantiateViewControllerWithIdentifier("ChatView") as! ChatViewController
        



        // Do any additional setup after loading the view.
        SwiftR.signalRVersion = .v2_2_0
        //SwiftR.useWKWebView = true
        chatConnection = SwiftR.connect("http://para.co.nz:80") { [weak self] connection in
            self?.chatHub = connection.createHubProxy("chatHub")
//            self?.chatHub?.on("recieve") { args in
//                if let conID = args?[0] as? String{
//                    print(conID)
//                }
//            }
            
            self?.chatHub?.on("recieveTextMessage") {args in
                if((args) != nil){
                    let message = SignalRChat()
                    let json = JSON(args![0])
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    var subUnreads = message.getAllUnreads()
                    
                    let data:ChatMsg = ChatMsg(picURL: "default", createdDate: formatter.dateFromString(json["CreateDate"].stringValue)!, content: json["MessageContent"].stringValue, senderEmail: json["FromUsername"].stringValue,firstName:json["FromUserFirstname"].stringValue,lastName:json["FromUserLastname"].stringValue,profile:json["FromUserProfilePhoto"].stringValue,msgStatus:"success")
                    var unreads = message.getUnreads(json["FromUsername"].stringValue)
                    if let currentViewController = self?.getPresentedView(){
                    if (currentViewController .isKindOfClass(ChatViewController)) {
                        let chatView = currentViewController as! ChatViewController
                        if(chatView.clientDetials.senderEmail == json["FromUsername"].stringValue){
//                            if(self!.allUnreads > unreads){
//                                chatNavController.tabBarItem.badgeValue = String(self!.allUnreads - unreads)
//                            }
                            unreads = 0
                            chatView.receiveMsg(data)
                            chatView.collectionView?.reloadData()
                            
                        }
                        else{
                            unreads += 1
                            subUnreads += 1
                            chatNavController.tabBarItem.badgeValue = String(subUnreads)
                        }
                    }
                    else{
                        unreads += 1
                        subUnreads += 1
                        chatNavController.tabBarItem.badgeValue = String(subUnreads)
                    }
                }
                    message.saveChatRecords(data, unreadMsg: unreads, type: "text", IamSender: false)
                    
                   
                    //chatViewController.chatReceive(data["FromUsername"].stringValue, content: data["MessageContent"].stringValue, createDate: formatter.dateFromString(data["CreateDate"].stringValue)!)
                    
                    
                    
                    if(chatListViewController.chatLists.count != 0){
                        chatListViewController.chatLists.sortInPlace({$0.createdDate.compare($1.createdDate) == .OrderedDescending})
                    }
                }
                
                
                chatListViewController.tableView?.reloadData()
                print(args)

            }
            
            self?.chatHub?.on("recieveImageMessage") {args in
                if((args) != nil){
                    let message = SignalRChat()
                    let json = JSON(args![0])
                    
                    //encap data
                    let formatter = NSDateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                    let picPath = "http://para.co.nz/api/ChatClient/GetChatImage/"+json["MessageContent"].stringValue
                    let data:ChatMsg = ChatMsg(picURL: picPath, createdDate: formatter.dateFromString(json["CreateDate"].stringValue)!, content: picPath, senderEmail: json["FromUsername"].stringValue,firstName:json["FromUserFirstname"].stringValue,lastName:json["FromUserLastname"].stringValue,profile:json["FromUserProfilePhoto"].stringValue,msgStatus:"success")
                    
                    
                    
                    //set up unread and Notification
                    var subUnreads = message.getAllUnreads()
                    var unreads = message.getUnreads(json["FromUsername"].stringValue)
                    if let currentViewController = self?.getPresentedView(){
                        if (currentViewController .isKindOfClass(ChatViewController)) {
                            let chatView = currentViewController as! ChatViewController
                            if(chatView.clientDetials.senderEmail == json["FromUsername"].stringValue){
                                unreads = 0
                                
                                //receive media to viewcontroller
                                chatView.receiveMedia("http://para.co.nz/api/ChatClient/GetChatImage/"+json["MessageContent"].stringValue)
                                chatView.collectionView?.reloadData()
                                
                            }
                            else{
                                unreads += 1
                                subUnreads += 1
                                chatNavController.tabBarItem.badgeValue = String(subUnreads)
                            }
                        }
                        else{
                            unreads += 1
                            subUnreads += 1
                            chatNavController.tabBarItem.badgeValue = String(subUnreads)
                        }
                    }
                    
                    
                    message.saveChatRecords(data, unreadMsg: unreads, type: "pic", IamSender: false)
                    
                    
                    //reorder chat list
                    if(chatListViewController.chatLists.count != 0){
                        chatListViewController.chatLists.sortInPlace({$0.createdDate.compare($1.createdDate) == .OrderedDescending})
                    }
                }
                
                
                chatListViewController.tableView?.reloadData()
                print(args)
                
            }
            // SignalR events
            connection.starting = { () in
                print("Starting...")
                
            }
            
            connection.reconnecting = { () in
                print("Reconnecting...")
            }
            
            connection.connected = { () in
                
                //let connectQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//                let chatConnectID = NSUserDefaults.standardUserDefaults()
//                chatConnectID.removeObjectForKey("ConnectionID")
//                chatConnectID.setObject(connection.connectionID!, forKey: "ConnectionID")
//                chatConnectID.synchronize()
                
                print("Connected! Connection ID: \(connection.connectionID!)")
                //dispatch_semaphore_signal(connectionSemaphore)
                let chat = SignalRChat()
                chat.registerConnection(connection.connectionID!)
                
                
                
                
            }
            
            connection.reconnected = { () in
                //let connectQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                //dispatch_async(connectQueue, {() -> Void in
//                let chatConnectID = NSUserDefaults.standardUserDefaults()
//                chatConnectID.removeObjectForKey("ConnectionID")
//                chatConnectID.setObject(connection.connectionID!, forKey: "ConnectionID")
//                chatConnectID.synchronize()
                print("Connected! Connection ID: \(connection.connectionID!)")
                
                //dispatch_semaphore_signal(connectionSemaphore)
                //})
                
            }
            
            connection.disconnected = { () in
                print("Disconnected...")
                // Try again after 5 seconds
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
                
                dispatch_after(delayTime, dispatch_get_main_queue()) {
                    connection.start()
                }
            }
            
            connection.connectionSlow = { print("Connection slow...") }
            
            connection.error = { error in
                print("Error: \(error)")
                
                // Here's an example of how to automatically reconnect after a timeout.
                //
                // For example, on the device, if the app is in the background long enough
                // for the SignalR connection to time out, you'll get disconnected/error
                // notifications when the app becomes active again.
                
                if let source = error?["source"] as? String  where source == "TimeoutException" {
                    print("Connection timed out. Restarting...")
                    // Try again after 5 seconds
                    let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
                    dispatch_after(delayTime, dispatch_get_main_queue()) {
                        connection.start()
                    }
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getPresentedView() -> UIViewController?{
        let appRootVC:UIViewController = (UIApplication.sharedApplication().keyWindow?.rootViewController)!
        if let tab = appRootVC as? CustomUITabBarController {
            if let selected = tab.selectedViewController as? UINavigationController{
                return selected.visibleViewController!
            }
        }
        else{
            return nil
        }
        return nil
//        var topVC:UIViewController = appRootVC
//        if ((topVC.presentedViewController) != nil) {
//            topVC = topVC.presentedViewController!;
//        }
        
        
    }
}
