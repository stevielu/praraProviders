//
//  ChatViewController.swift
//  Provider
//
//  Created by imac on 1/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//


import UIKit
import JSQMessagesViewController
import SwiftyJSON
import SKPhotoBrowser
import Kingfisher

struct sendStatus {
    var indexPath = 0
    var status = false
}

class ChatViewController: JSQMessagesViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,SKPhotoBrowserDelegate {
    
    var messages = [JSQMessage]()
    var AvatarIdWoz:String!
    var chatContents:[tb_c2cMsg_Content]?
    var clientDetials = chatDetials()
    let incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(globalStyle.chatIncomingColor)
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(globalStyle.chatOutgoingColor)
    let serverDataProcess = ServiceDataProcess()
    var senderName = "Anonymous"
    var didDoFirstLayout = false
    var pageID = 0
    let netWorkErrAlert = UILabel()
    let imagePicker =  UIImagePickerController()
    var latestedSendIndex = sendStatus(indexPath: 0, status: false)
    let myBtn: UIButton = UIButton()
    //var contentView = JSQMessagesCollectionView()
    //var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accessoryBtn = JSQMessagesToolbarButtonFactory.defaultAccessoryButtonItem()
        //accessoryBtn.addTarget(self, action: #selector(self.mediaAction), forControlEvents: UIControlEvents.TouchUpInside)
        self.inputToolbar?.contentView?.leftBarButtonItem = accessoryBtn
        
        
        //myBtn.setImage(self.conversation?.avatar.image, forState: .Normal)
        
        myBtn.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        myBtn.backgroundColor = globalStyle.backgroundColor2
        myBtn.layer.cornerRadius = 0.5 * myBtn.bounds.size.width
        myBtn.layer.borderWidth = 1.0
        myBtn.layer.borderColor = UIColor.whiteColor().CGColor
        //myBtn.addTarget(self, action: "myBtnAction:", forControlEvents: .TouchUpInside)
        let barButton = UIBarButtonItem()
        barButton.customView = myBtn
        self.navigationItem.rightBarButtonItem = barButton
        imagePicker.delegate = self
        //fetch client profile
        self.serverDataProcess.JSONDataGet("http://para.co.nz/api/ClientProfile/GetClientDetail/"+self.clientDetials.senderEmail, LookUpforClassbyKey: "ClientProfile",pushAction:false){(data) in
            if(data as? String == "Fail"){
                self.alertAnimator()
                return
            }
            else{
                
                let clientInfo = data as! ClientProfile
                self.clientDetials.userLastName = clientInfo.LastName
                self.clientDetials.userFirstName = clientInfo.FirstName
                self.clientDetials.userProfile = clientInfo.ProfilePicture
                self.navigationItem.title = self.clientDetials.userLastName
                if(self.clientDetials.userProfile == ""){
                    self.myBtn.setImage(UIImage(named: "default"), forState: .Normal)
                }
                else{
                    var avatarThumbnail = UIImageView(image: UIImage(named: "default"))
                    self.serverDataProcess.retrieveCellImg("http://para.co.nz/api/ClientProfile/GetClientProfileImage/"+(self.clientDetials.userProfile), image: avatarThumbnail,completion: {error in
                        if(error == nil){
                            
                        }
                        else{
                           avatarThumbnail = UIImageView(image: UIImage(named: "default"))
                        }
                    })
                    self.myBtn.setImage(avatarThumbnail.image, forState: .Normal)
                }
            }
            
        }
        
        
        
       
    
        //self.navigationItem.setRightBarButtonItem(UIBarButtonItem(customView: myBtn), animated: true)
        //self.navigationItem.rightBarButtonItem?.setBackgroundImage(UIImage(named: "default"), forState: .Normal, barMetrics:.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // This is how you remove Avatars from the messagesView
        collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        
        // This is a beta feature that mostly works but to make things more stable I have diabled it.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        //Set the SenderId  to the current User
        // For this Demo we will use Woz's ID
        // Anywhere that AvatarIDWoz is used you should replace with you currentUserVariable
        self.AvatarIdWoz = (NSUserDefaults.standardUserDefaults().objectForKey("ActiveUser") as! String)
        senderId = self.AvatarIdWoz
        //senderId = "309-41802-93823"
        self.senderName = self.clientDetials.userLastName ?? self.clientDetials.senderEmail ?? "Anonym"
        automaticallyScrollsToMostRecentMessage = true
        //loading
        let chat = SignalRChat()
        self.pageID = chat.getLastID(clientDetials.senderEmail)
        if self.pageID != -1 {
            loadRecords()
        }
        
        //Loading history
//        if (conversation?.smsNumber) != nil {
//            self.messages = makeConversation()
//            self.collectionView?.reloadData()
//            self.collectionView?.layoutIfNeeded()
//        }
        

        netWorkErrAlert.frame = CGRect(x: 0, y: -50, width: globalStyle.screenSize.width, height: 25)
        netWorkErrAlert.font = globalStyle.dateTitleFont
        netWorkErrAlert.text = "Network Error!"
        netWorkErrAlert.backgroundColor = globalStyle.warningColor
        netWorkErrAlert.textColor = globalStyle.nameTextColor
        netWorkErrAlert.alpha = 0;
        netWorkErrAlert.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(netWorkErrAlert)
        
        self.collectionView.addPullRefreshHandler({ [weak self] in
            
            if(self?.pageID != 1){
                self?.pageID -= 1
                self?.loadRecords()
            }
            self?.collectionView?.reloadData()
            self?.collectionView?.stopPullRefreshEver(false)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        self.collectionView?.layoutIfNeeded()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if(!self.didDoFirstLayout){
            if (self.automaticallyScrollsToMostRecentMessage) {
                self.finishSendingMessageAnimated(false)
            }
            self.didDoFirstLayout = true
        }
    }
    
    func loadRecords(){
        let chat = SignalRChat()
        self.chatContents = chat.fetchRecordsWithPageID(clientDetials.senderEmail, pageID: self.pageID)//chat.fetchRecords(clientDetials!.senderEmail)
        if(self.chatContents != nil){
//            let contentID = self.chatContents?.last?.contentID
//            var currentRead = 0
//            var readCnt = contentID! - 10
//            if(contentID < 0){
//            }
            var msgarray = [JSQMessage]()
            for item in self.chatContents! {
                //currentRead = item.contentID
                self.senderName = self.clientDetials.userLastName ?? self.clientDetials.senderEmail ?? "Anonym"
                
                if (item.contentType == "pic") {
                    let url = NSURL(string:item.content)
                    let imageView = UIImageView()
                    let mediaItem = JSQPhotoMediaItem(image: nil)
                   
                    
                    if(item.senderEmail == self.AvatarIdWoz){
                        mediaItem.appliesMediaViewMaskAsOutgoing = true
                        mediaItem.image = loadImageFromPath(fileInDocumentsDirectory(item.content))
                    }else{
                        mediaItem.appliesMediaViewMaskAsOutgoing = false
                        imageView.kf_setImageWithURL(url,completionHandler: { image, error, cacheType, imageURL in
                            //if(error != nil){
                            mediaItem.image = imageView.image
                            self.collectionView?.reloadData()
                            //}
                            //else{
                            //    print(error)
                            //}
                            
                        })
                    }
                    let msg = JSQMessage(senderId: item.senderEmail, displayName:  self.senderName, media: mediaItem)
                    msg.status.value = item.messageStatus
                    msgarray.append(msg)
                    self.finishReceivingMessageAnimated(true)
                    //let img = JSQPhotoMediaItem(image:imageView)
                    
                    //msgarray.append(JSQMessage(senderId: item.senderEmail, senderDisplayName: self.senderName, date: item.createdDate, text: item.content))
                }
                else{
                    let msg = JSQMessage(senderId: item.senderEmail, senderDisplayName: self.senderName, date: item.createdDate, text: item.content)
                    msg.status.value = item.messageStatus
                    msgarray.append(msg)
                }
                
            }
            self.messages.insertContentsOf(msgarray, at: 0)

        }
    }
    
//    func refreshContent(){
//        self.collectionView?.reloadData()
//    }
    
    func receiveMsg(data:ChatMsg){
        self.messages.append(JSQMessage(senderId:data.senderEmail, senderDisplayName: data.lastName, date: data.createdDate, text: data.content))
        self.finishReceivingMessageAnimated(true)
        
    }
    
    func receiveMedia(imageURL:String){
//        self.serverDataProcess.JSONDataGet("http://para.co.nz/api/ChatClient/GetChatImage/"+imageURL, LookUpforClassbyKey: "FetchImagefile", pushAction: false, completion: {(data) in
//        })
        //self.messages.append(JSQMessage(senderId:data.senderEmail, senderDisplayName: data.lastName, date: data.createdDate, text: data.content))
        let url = NSURL(string:imageURL)
        let imageView = UIImageView()
        
        imageView.kf_setImageWithURL(url,completionHandler: { image, error, cacheType, imageURL in
                                        //if(error != nil){
                                            let mediaItem = JSQPhotoMediaItem(image: nil)
                                            mediaItem.image = imageView.image
                                            mediaItem.appliesMediaViewMaskAsOutgoing = false
                                            self.messages.append(JSQMessage(senderId: self.clientDetials.senderEmail, displayName: self.clientDetials.userLastName, media: mediaItem))
                                            self.finishReceivingMessageAnimated(true)
                                        //}
                                        //else{
                                        //    print(error)
                                        //}
        })
        

        
    }
    
    
    override func didPressSendButton(button: UIButton?, withMessageText text: String?, senderId: String?, senderDisplayName: String?, date: NSDate?) {
        
        // This is where you would impliment your method for saving the message to your backend.
        //
        // For this Demo I will just add it to the messages list localy
        //
        let msg = JSQMessage(senderId:self.AvatarIdWoz, senderDisplayName: "stev", date: date, text: text)
        self.messages.append(msg)
        self.finishSendingMessageAnimated(true)
        self.collectionView?.reloadData()
        let chat = SignalRChat()
        self.latestedSendIndex.indexPath = self.messages.endIndex - 1
        self.latestedSendIndex.status = true
        chat.sendMessage(text!, senderEmail: (self.clientDetials.senderEmail),completion: { data in
            if(data != true){
                //self.latestedSendIndex.status = false
                self.collectionView?.reloadData()
                msg.status.value = "Fail"
                //let cell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! JSQMessagesCollectionViewCell

            }
            let records:ChatMsg = ChatMsg(picURL: "default", createdDate: NSDate(), content: text!, senderEmail: (self.clientDetials.senderEmail),firstName:self.clientDetials.userFirstName,lastName:self.clientDetials.userLastName,profile:self.clientDetials.userProfile,msgStatus:msg.status.value )
            print(records.msgStatus)
            chat.saveChatRecords(records, unreadMsg: 0, type: "text",IamSender: true)
        })
        
        
        //Save records

        
    }
    

    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAtIndexPath indexPath: NSIndexPath!) {
        let message = messages[indexPath.item]
  
        if(message.isMediaMessage){
            let mediaItem:JSQMessageMediaData = message.media;
            if (mediaItem.isKindOfClass(JSQPhotoMediaItem)) {
                let photoItem:JSQPhotoMediaItem = mediaItem as! JSQPhotoMediaItem;
                if let image:UIImage = photoItem.image{
                    let browser = imageDisplayFullScreen(image)
                    // change the size of the image view so that it fills the whole screen
                    self.presentViewController(browser, animated: true, completion: {})
                }
            }
        }
        self.view.endEditing(true)
    }
    
    // set text color based on who is sending the messages
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
    
        let message = messages[indexPath.item]
        
        if(message.isMediaMessage == false){
            if message.senderId == senderId {
                cell.textView?.textColor = UIColor.whiteColor()
            } else {
                cell.textView?.textColor = UIColor.blackColor()
            }
        }
        
        return cell
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        //check if outgoing
        if (self.senderId == messages[indexPath.item].senderId) {
            print(messages[indexPath.item].status.value)
            if let status:String? = messages[indexPath.item].status.value{
            if(status == "Fail"){
                let starAttr = NSMutableAttributedString(string:"Send Fail \t")
                starAttr.addAttribute(NSForegroundColorAttributeName, value:globalStyle.deliverStatus, range: NSMakeRange(0,starAttr.length))
                starAttr.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(8), range: NSMakeRange(0,starAttr.length))
                return starAttr
                }
            }
        }
        //return nothing for incoming messages
        return nil;
    }
    

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData? {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource? {
        return messages[indexPath.item].senderId == AvatarIdWoz ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource? {
        return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        switch message.senderId {
        case AvatarIdWoz:
            return nil
        default:
            guard let senderDisplayName = message.senderDisplayName else {
                assertionFailure()
                return nil
            }
            return NSAttributedString(string: senderDisplayName)
            
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//        if(indexPath.item % 5 == 0){
            let message:JSQMessage = self.messages[indexPath.item]
            print(message.date)
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date!)
//        }
  //      return nil
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView?, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout?, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
//        if(indexPath.item % 5 == 0){
            return messages[indexPath.item].senderId == AvatarIdWoz ? 0 : kJSQMessagesCollectionViewCellLabelHeightDefault
//        }
//        else{
//            return 0.0;
//        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        return messages[indexPath.item].senderId == AvatarIdWoz ?  kJSQMessagesCollectionViewCellLabelHeightDefault : 0
    }
    
    override func collectionView(collectionView:JSQMessagesCollectionView?, didTapCellAtIndexPath indexPath: NSIndexPath, touchLocation:CGPoint) {
        self.view.endEditing(true)
    }
    
    
    
    override func didPressAccessoryButton(sender: UIButton!) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        print(messages)
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func chatReceive(senderID:String,content text:String,createDate date:NSDate){
        print(senderID)
    }
    
    func alertAnimator(){
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 25, 0)
        self.netWorkErrAlert.layer.transform = CATransform3DIdentity
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.netWorkErrAlert.layer.transform = transform
            self.netWorkErrAlert.alpha = 1
            }, completion: nil)
    }
    
    
    

    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        if let imageView:UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            let chat = SignalRChat()
            //Compress Image and upload
            let imageCompressed = help.resetSizeOfImageData(imageView, maxSize: globalStyle.imageCompressMaxSize)
           
            chat.sendMedia(Image: imageCompressed, senderEmail: clientDetials.senderEmail)
            
            //show compressed image
            let mediaItem = JSQPhotoMediaItem(image: nil)
            mediaItem.appliesMediaViewMaskAsOutgoing = true
            mediaItem.image = UIImage(data: imageCompressed)
            
            //let img = JSQPhotoMediaItem(image:imageView)
            self.messages.append(JSQMessage(senderId: AvatarIdWoz, displayName: "Default", media: mediaItem))
            self.finishSendingMessageAnimated(true)
            self.collectionView?.reloadData()
            
            //save compressed image to local
            let imageName = NSUUID().UUIDString
            saveImage(imageCompressed, path: fileInDocumentsDirectory(imageName))
            
            let records:ChatMsg = ChatMsg(picURL: imageName, createdDate: NSDate(), content: imageName, senderEmail: (self.clientDetials.senderEmail),firstName:self.clientDetials.userFirstName,lastName:self.clientDetials.userLastName,profile:self.clientDetials.userProfile,msgStatus: "success")
            chat.saveChatRecords(records, unreadMsg: 0, type: "pic",IamSender: true)
        }
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

class deliverStatus{
    var value:String = ""
    
}
private var catKey: UInt8 = 0
extension JSQMessage{
    
    var status: deliverStatus {
        get {
            return help.associatedObject(self, key: &catKey)
            { return deliverStatus()  } // Set the initial value of the var
        }
        set { help.associateObject(self, key: &catKey, value: newValue) }
    }
}

