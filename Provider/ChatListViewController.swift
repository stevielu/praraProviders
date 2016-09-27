//
//  ChatListViewController.swift
//  Provider
//
//  Created by imac on 1/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import JSQMessagesViewController



class ChatListViewController: UITableViewController {

    var conversations = [ConversationList]()
    var convo = ConversationList(name: "Stevie", email: "Jobs", avatar:  UIImageView(image:UIImage(named: "default.png")),latestMessage: "")
    var chatLists = [tb_c2cTables]()
    let chat = SignalRChat()
    var unreadList = [unreadFormat]()
    let serverDataProcess = ServiceDataProcess()
    var IdWoz = ""
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
       
        self.IdWoz = (NSUserDefaults.standardUserDefaults().objectForKey("ActiveUser") as! String)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if let myTabBarView = (appDelegate.window?.rootViewController as? UITabBarController){
            let svc = myTabBarView.viewControllers![1]
            let subUnreads = self.chat.getAllUnreads()
            if(subUnreads == 0){
                svc.tabBarItem.badgeValue = nil
            }
            else{
                svc.tabBarItem.badgeValue = String(subUnreads)
            }
            
        }


        //self.tabBarItem.badgeValue = String(subUnreads)
        
        if (chat.fetchChatLists(IdWoz) != nil ){
            self.chatLists = chat.fetchChatLists(IdWoz)!
        }
        
        //self.conversations[0] = convo
        //self.conversations.append(convo)
        //self.conversations = getConversation()
        self.tableView?.reloadData()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.tableView.delegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.rowHeight = 75.0
        self.tableView.separatorColor = globalStyle.bgColor1
        self.tableView.registerClass(ConversationTableViewCell.self, forCellReuseIdentifier: "chatCell")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 97.5, 0)
        self.tableView.frame = CGRect(x: 0, y: 50, width: globalStyle.screenSize.width, height: globalStyle.screenSize.height)
        //self.view.addSubview(self.tableView)
        //self.conversations.append(convo)
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (chat.fetchChatLists(IdWoz) != nil ){
            self.chatLists = chat.fetchChatLists(IdWoz)!
        }
        return self.chatLists.count
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let conversation = self.chatLists[(indexPath as NSIndexPath).row]
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as? ConversationTableViewCell else {
            return UITableViewCell()
        }
        

        
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins =  UIEdgeInsetsMake(0, globalStyle.avatarSize.width+25, 0, 0)
        //        cell.avatarView.setup(conversation.patientId)
        //cell.userEmail = conversation.senderEmail
        cell.UserName.text = conversation.userLastName
        //conversation.avatar.image = UIImage(named: "default")
        print(conversation.userProfile)
        if(conversation.userProfile == ""){
            cell.UserAvatar.image = UIImage(named: "default")
        }
        else{
            self.serverDataProcess.retrieveCellImg("http://para.co.nz/api/ClientProfile/GetClientProfileImage/"+conversation.userProfile, image: cell.UserAvatar,completion: {error in
                if(error == nil){
                    //self.tableView.reloadData()
                }
                else{
                    cell.UserAvatar.image = UIImage(named: "default")
                    //self.tableView.reloadData()
                }
            })
        }
        //cell.UserAvatar.image = UIImage(named: "default")
        if(conversation.latestedMsgType == "pic"){
            cell.latestMsg.text = "[picture]"
        }else{
            cell.latestMsg.text = conversation.latestedMsg
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.stringFromDate(conversation.createdDate)
        print(date)
        cell.latestDate.text = date
        
        if(conversation.unreadMsg != 0){
            cell.badge.alpha = 1.0
            cell.badge.text = String(conversation.unreadMsg)
//            cell.badge.snp_makeConstraints{(make) in
//                make.edges.equalTo(cell).inset(UIEdgeInsets(top: 32.5, left: globalStyle.screenSize.width-26, bottom: 32.5, right: 12.5))
//            }
        }
        else{
            cell.badge.alpha = 0.0
        }
        
        //cell.UserAvatar.image = conversation.avatar.image!.reSizeImage(CGSize(width: 50, height: 50))
//        if let avatar = conversation.avatar.image{
//            cell.UserAvatar.image = avatar.reSizeImage(CGSize(width: 50, height: 50))
//        }
         //?.RBSquareImageTo(globalStyle.avatarSize)

        //cell.recentTextLabel.text = conversation.latestMessage
        
        // Check if the conversation is read and apply Bold/Not Bold to the text to indicate Read/Unread state
        //!conversation.isRead ? cell.nameLabel.font = cell.nameLabel.font.bold() : (cell.nameLabel.font = cell.nameLabel.font.withTraits([]))
//        let firstRow = NSIndexPath(forRow: 1, inSection: 0)
//        if(unreadList.count != 0){
//            for item in unreadList {
//                if (item.userName == cell.userEmail){
//                    if(item.unreads != 0){
//                        self.tableView.moveRowAtIndexPath(indexPath, toIndexPath:firstRow)
//                    }
//                }
//            }
//        }
        return cell
    }
    
//    override func tableView(tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: NSIndexPath) {
//        print(destinationIndexPath)
//    }
//    override func tableView(tableView: UITableView, canMoveRowAt indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the item to be re-orderable.
//        return true
//    }
    

    /*
    // MARK: - Navigation
     

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let conversation = self.chatLists[indexPath.row]
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ConversationTableViewCell{
            cell.badge.alpha = 0.0
            cell.badge.text = String(0)
            
        }
        if(conversation.unreadMsg != 0){
            chat.clearUnreads(conversation.senderEmail)
        }
        self.performSegueWithIdentifier("toChat", sender: indexPath.row)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            chat.deleteRecord(self.chatLists[indexPath.row].senderEmail)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let conversationController = segue.destinationViewController as? ChatViewController, let row = sender as? Int {
            let conversation = self.chatLists[row]
            conversationController.clientDetials = chatDetials(senderEmail: conversation.senderEmail, latestedMsg: conversation.latestedMsg, userFirstName: conversation.userFirstName, userLastName: conversation.userLastName, userProfile: conversation.userProfile, unreadMsg: conversation.unreadMsg, createdDate: conversation.createdDate)
            conversationController.hidesBottomBarWhenPushed = true
        }
    }

}
