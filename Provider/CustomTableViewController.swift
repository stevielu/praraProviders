//
//  CustomTableViewController.swift
//  Provider
//
//  Created by imac on 4/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import SwiftyJSON
import ReachabilitySwift

protocol cellButtonDelegate {
    func didPressChatButton(sender:myButton)
}

class CustomTableViewController: UITableViewController {
    var providersArray = [JobServiceAttr]()
    var shareData:JobServiceAttr?
    var filteredRestults = [JobServiceAttr]()
    let serverDataProcess = ServiceDataProcess()
    var lastSelectedRow = NSIndexPath(forRow: 0, inSection: 0)
    var firstTriggerSelected = true
    var shouldShowSearchResults = false
    var userSearchRecords = NSUserDefaults()
    let indicator = UIActivityIndicatorView()
    //let netWordErrAlert = UILabel(frame: CGRectMake(0, -25, globalStyle.screenSize.width, 25))
    var cellDidSelected = false
    let netWorkErrAlert = UILabel()
    var reachability: Reachability!
    var pageId = 0
    var btnDelegate:cellButtonDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        //self.tableView.frame = CGRectMake(0, 25, globalStyle.screenSize.width, globalStyle.screenSize.height)
        self.tableView.rowHeight = 75.0
        self.tableView.separatorColor = globalStyle.backgroundColor
        self.tableView.registerClass(ServiceJobCell.self, forCellReuseIdentifier: "cellId")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 97.5, 0)
        self.tableView.tableFooterView = UIView()
        fetchDataFromLocal()
        indicator.color = globalStyle.subTitleColor3
        indicator.frame = CGRect(x: 0, y: 0, width: globalStyle.screenSize.width, height: -25)
        self.view.addSubview(indicator)
        
        netWorkErrAlert.frame = CGRect(x: 0, y: -50, width: globalStyle.screenSize.width, height: 25)
        netWorkErrAlert.font = globalStyle.dateTitleFont
        netWorkErrAlert.text = "Network Error!"
        netWorkErrAlert.backgroundColor = globalStyle.warningColor
        netWorkErrAlert.textColor = globalStyle.nameTextColor
        netWorkErrAlert.alpha = 0;
        netWorkErrAlert.textAlignment = NSTextAlignment.Center;
        self.view.addSubview(netWorkErrAlert)
        //listening network status
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            help.listeningNetworkStatus(reachability)
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        
        reachability.whenUnreachable = { reachability in
            UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
                self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 97.5, 0)
                self.tableView.contentOffset.y = -25
                }, completion:nil)
            self.alertAnimator()
            let chatConnectID = NSUserDefaults.standardUserDefaults()
            chatConnectID.removeObjectForKey("ConnectionID")
            
        }
        reachability.whenReachable = { reachability in
            //self.startLoadingAnimation()
            sleep(1)
            self.refreshContent(pullAction:false,pushAction: false)
            
            //dispatch_semaphore_wait(connectionSemaphore, DISPATCH_TIME_FOREVER);
            
        }
        
        //self.tableView.startPullRefresh()
        self.tableView.addPullRefreshHandler({ [weak self] in   
            sleep(1)
            self?.refreshContent(pullAction:true,pushAction: false)
            
        })
        
//        self.tableView.addPushRefreshHandler({ [weak self] in
//            sleep(1)
//            self?.refreshContent(pullAction:false,pushAction: true)
//            
//        })
        
        startLoadingAnimation()
        
        //self.refreshControl = contentRefresher
        //contentRefresher.beginRefreshing()
        //refreshContent()
       
//        let testBtn = UIButton(frame: CGRectMake(50, 50, 50, 30))
//        testBtn.addTarget(self, action: #selector(self.testRequest), forControlEvents: UIControlEvents.TouchUpInside)
//        testBtn.layer.backgroundColor = UIColor.blackColor().CGColor
//        self.view.addSubview(testBtn)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        serverDataProcess.JSONDataGet("http://para.co.nz/api/JobService/GetAllJobServices", Keywords: "test", MaxItemsBuffered: 50, LookUpforClassbyKey: "JobServiceAttr")
        
    }
    
    override func viewDidAppear(animated: Bool) {
       self.pageId = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(shouldShowSearchResults){
            return filteredRestults.count
        }
        else{
            return providersArray.count
        }
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ServiceJobCell {
        self.shareData = self.providersArray[(indexPath as NSIndexPath).row]
            
        if(self.cellDidSelected == false){
            self.cellDidSelected = true
            cellAnimatorMoveIn(cell)
            cell.postDate.textColor = globalStyle.greenColorS2
            UIView.animateWithDuration( 0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
                self.cellAnimatorMoveOut(cell)
            }, completion: nil)
            cell.returnBtn.indexPath = indexPath
            cell.userChat.indexPath = indexPath
            }
        }
        
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? ServiceJobCell {
        self.cellDidSelected = false
        self.cellAnimatorMoveIn(cell)
        cell.workType.alpha = 1
        cell.subTitle.alpha = 1
        cell.postDate.textColor = globalStyle.subTitleColor2
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath) as! ServiceJobCell
        //var provider : Provider = Provider(type:"Other", date:NSDate(), model: "Newnergy", image: "default.png",subtitle:"")
        var provider = JobServiceAttr() //= Provider(type:"Other", date:NSDate(), model: "Newnergy", image: "default.png",subtitle:"")
//        if let selection:NSIndexPath = tableView.indexPathForSelectedRow{
//            //var selectedCell = self.tableView.cellForRowAtIndexPath(selection) as! ServiceJobCell
//            if(selection.row == indexPath.row){
//     
//            }
//            else{
//                
//            }
//        }
        
        
        // Configure the cell...
        cell.selectionStyle = .None
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        //cell.separatorInset = UIEdgeInsetsZero
        if(shouldShowSearchResults){
            provider = filteredRestults[(indexPath as NSIndexPath).row]
        }
        else{
            provider = providersArray[(indexPath as NSIndexPath).row]
        }

        cell.UserName.text = provider.clientName
        
        let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let today = dateFormatter.stringFromDate(currentDate)
        
        let diffDate = help.differenceDate(lateDate: today, earlierDate: dateFormatter.stringFromDate(provider.createDate! as NSDate))

        if(diffDate.day == 0){
            cell.postDate.text = "List Today"
        }
        else if(diffDate.day > 7 || diffDate.month >= 1 || diffDate.year >= 1){
            cell.postDate.text = dateFormatter.stringFromDate(provider.createDate!)
        }
        else if(diffDate.day == 1){
            cell.postDate.text = "Yesterday"
        }
        else{
            cell.postDate.text = String(format: "%d Days Ago", diffDate.day)
        }
        cell.subTitle.text = provider.title
        cell.workType.text = provider.type
        

        serverDataProcess.retrieveCellImg("http://para.co.nz/api/ClientProfile/GetClientProfileImage/"+provider.profilePhoto!, image: cell.UserAvatar,completion: {error in
            if(error == nil){
                //self.tableView.reloadData()
            }
            else{
                cell.UserAvatar.image = UIImage(named: "default")
                //self.tableView.reloadData()
            }
        })
        //
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        cell.returnBtn.addTarget(self, action: #selector(self.backBtn), forControlEvents: UIControlEvents.TouchUpInside)
        cell.userChat.addTarget(self, action: #selector(self.chatBtn), forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
//    func chatBtn(sender:myButton){
//            let indexPath = sender.indexPath
//            self.shareDate = self.providersArray[indexPath.row]
//            self.performSegueWithIdentifier("toChat1", sender: self)
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
////        if segue.identifier == "toChat"{
////            if let dest = segue.destinationViewController as?  ChatViewController{
////                dest.chatOneDetials = self.shareDate
////            }
////        }
//    }
//    
    func chatBtn(sender:myButton) {
        self.btnDelegate.didPressChatButton(sender)

    }
    
    func backBtn(sender:myButton) {
        let indexPath = sender.indexPath
        let currentCell = tableView.cellForRowAtIndexPath(indexPath) as! ServiceJobCell
        self.cellAnimatorMoveIn(currentCell)
        cellDidSelected = false
         UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() ->  Void in
            //self.cellAnimatorMoveIn(currentCell)
            currentCell.workType.alpha = 1
            currentCell.subTitle.alpha = 1
            }, completion: nil)
    }
    
    func cellAnimatorMoveIn(cell:ServiceJobCell){
        let moveInTransform = CATransform3DTranslate(CATransform3DIdentity, globalStyle.screenSize.width, 0, 0)
        cell.userDetails.layer.transform = moveInTransform
        cell.userAddress.layer.transform = moveInTransform
        cell.userPhone.layer.transform = moveInTransform
        cell.userChat.layer.transform = moveInTransform
        cell.returnBtn.layer.transform = moveInTransform
    }
    
    func cellAnimatorMoveOut(cell:ServiceJobCell){
        cell.userDetails.layer.transform = CATransform3DIdentity
        cell.userAddress.layer.transform = CATransform3DIdentity
        cell.userPhone.layer.transform = CATransform3DIdentity
        cell.userChat.layer.transform = CATransform3DIdentity
        cell.returnBtn.layer.transform = CATransform3DIdentity
        //                cell.subTitle.layer.transform = moveInTransform
        //                cell.workType.layer.transform = moveInTransform
        cell.workType.alpha = 0
        cell.subTitle.alpha = 0
        cell.userDetails.alpha = 1
        cell.userAddress.alpha = 1
        cell.userPhone.alpha = 1
        cell.userChat.alpha = 1
        cell.returnBtn.alpha = 1
    }
    
    func alertAnimator(){
        let transform = CATransform3DTranslate(CATransform3DIdentity, 0, 25, 0)
        self.netWorkErrAlert.layer.transform = CATransform3DIdentity
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.netWorkErrAlert.layer.transform = transform
            self.netWorkErrAlert.alpha = 1
            }, completion: nil)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        self.tableView.fixedPullToRefreshViewForDidScroll()
        if(scrollView.dragging){
        if let selection:NSIndexPath = tableView.indexPathForSelectedRow{
            if let cell = self.tableView.cellForRowAtIndexPath(selection) as? ServiceJobCell{
            
                UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
                    self.cellAnimatorMoveIn(cell)
                    cell.workType.alpha = 1
                    cell.subTitle.alpha = 1
                    cell.postDate.textColor = globalStyle.subTitleColor2
                    self.cellDidSelected = false
                    }, completion: nil)
            }
        }
        }
    }
    
    
    
    
    
    
    
    func fetchDataFromLocal(){
        if let dataArray:NSData = serverDataProcess.checkServerDataExistInCache("ServiceList") as? NSData{
            if let disk = NSKeyedUnarchiver.unarchiveObjectWithData(dataArray) as? [JobServiceAttr] {
                self.providersArray = disk
//                for providerItem in disk{
//                    let newUser : Provider = Provider(type:providerItem.type! , date: (providerItem.createDate)! , model: (providerItem.clientName)!, image: (providerItem.profilePhoto)! ,subtitle:(providerItem.title)! )
//                    self.providersArray.append(newUser)
//                    //print(newUser)
//                }
            }
            self.tableView.reloadData()
        }
    }
    
    func refreshContent(pullAction pullAct:Bool,pushAction pushAct:Bool)-> Void{
            //self.startLoadingAnimation()
            var pID = 0
            if(pullAct){
                pID = 0
            }
            else if(pushAct){
                pID = self.pageId
            }
        
        serverDataProcess.JSONDataGet("http://para.co.nz/api/JobService/GetAllJobServices?"+String(pID), LookUpforClassbyKey: "JobServiceAttr",pushAction:pushAct){(data) in
                
                if(data as? String == "Fail"){
                    self.alertAnimator()
                    self.indicator.stopAnimating()
                    if(pullAct){
                        self.tableView.stopPullRefreshEver(false)
                    }
                    return
                }
                else{
                    self.netWorkErrAlert.alpha = 0
                    //let json = JSON(data)
//                    let formatter = NSDateFormatter()
//                    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
                    
                    self.providersArray.removeAll()
                    self.providersArray = data as! [JobServiceAttr]
//                    for providerItem in json.array!{
//                    
//                        let newUser : Provider = Provider(type:providerItem["Type"].stringValue , date: (formatter.dateFromString(providerItem["CreatedDate"].stringValue))! , model: (providerItem["ClientName"].stringValue), image: (providerItem["ProfilePhoto"].stringValue) ,subtitle:(providerItem["Title"].stringValue) )
//                        self.providersArray.append(newUser)
//                    //print(newUser)
//                    }
                
                    //self.stopLoadingAnimation()
                    
                    self.tableView.reloadData()
                }
                
                sleep(1)
                self.stopLoadingAnimation()
                if(pullAct){
                    self.tableView.stopPullRefreshEver(false)
                }
            }
        return
    }

    func startLoadingAnimation(){
        
        UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.tableView.contentInset = UIEdgeInsetsMake(25, 0, 97.5, 0)
            self.tableView.contentOffset.y = -25
            }, completion:nil)
        
        self.indicator.startAnimating()
    }
    func stopLoadingAnimation(){
        UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 97.5, 0)
            self.tableView.contentOffset.y = 0
            }, completion:nil)
        indicator.stopAnimating()
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


