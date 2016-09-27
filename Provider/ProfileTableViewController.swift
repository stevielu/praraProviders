//
//  ProfileTableViewController.swift
//  Provider
//
//  Created by imac on 27/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import SKPhotoBrowser
import Kingfisher
import SnapKit

class ProfileViewController:UIViewController,UITableViewDataSource, UITableViewDelegate  {
    
    
    var mydetails : myAccount? = nil
    let serverDataProcess = ServiceDataProcess()
    var settingTable = UITableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "My Setting"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        settingTable.tableView.delegate = self
        settingTable.tableView.dataSource = self
        settingTable.tableView.tableFooterView = UIView()
        settingTable.tableView.registerClass(MySettingCell.self, forCellReuseIdentifier: "mySettingCell")
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewMyaccount(sender:UIButton) {
        performSegueWithIdentifier("myAccount", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "myAccount" {
            let controller = segue.destinationViewController as! myAccountViewController
            controller.myDetials = self.mydetails
        }
//        } else if segue.identifier == "historySegue" {
//            let controller = segue.destinationViewController as! HistoryViewController
//            controller.history = self.history
//        }
    }
    
    func setUp() {
        
        //initail layouts
        let avatarButton = UIButton()
        let myName = UILabel()
        
        //layout
        avatarButton.frame = CGRect(x: globalStyle.screenSize.width/2 - 50, y: 75, width: 100, height: 100)
        myName.frame = CGRect(x: 12.5, y: 75+12.5+100, width: globalStyle.screenSize.width-12.5, height: 25)
        settingTable.tableView.frame = CGRect(x: 12.5, y: 75+12.5+25+100, width: globalStyle.screenSize.width, height: globalStyle.screenSize.height)
        
        avatarButton.layer.borderWidth = 0.5
        avatarButton.layer.borderColor = globalStyle.subTitleColor4.CGColor
        avatarButton.layer.masksToBounds = false
        avatarButton.clipsToBounds = true
        
        
        self.mydetails = fetchProfileFromLocal()
        if(self.mydetails?.userProfile != nil){
            let image = UIImageView()
            image.image = help.reSizeImage(scaledToSize: globalStyle.myProfileSize)
            serverDataProcess.retrieveCellImg(self.mydetails!.userProfile, image: image, completion: {error in
                    if(error == nil){
                        
                        avatarButton.setImage(image.image, forState:.Normal)
                    }
                    else{
                        avatarButton.setImage(UIImage(named: "default"), forState:.Normal)
                    }
            })
        }else{
            avatarButton.setImage(UIImage(named: "default"), forState:.Normal)
        }
        
        avatarButton.layer.cornerRadius = 6.0
        avatarButton.layer.cornerRadius = 0.5 * avatarButton.bounds.size.width
        avatarButton.addTarget(self, action: #selector(self.viewMyaccount), forControlEvents: UIControlEvents.TouchUpInside)
        
        if let firstname = self.mydetails?.userLastName ,let lastname = self.mydetails?.userLastName{
             myName.text =  firstname+lastname
        }
       
        myName.textAlignment = .Right
        myName.textColor = globalStyle.titleColor
        myName.font = globalStyle.nameTitleFont

        
        
        //add views
        self.view.addSubview(avatarButton)
        self.view.addSubview(settingTable.tableView)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("mySettingCell", forIndexPath: indexPath) as? MySettingCell else {
            return UITableViewCell()
        }
        if(indexPath.row == 0){
            cell.cellTitle.text = "Payment Method"
        }
        if(indexPath.row == 1){
            cell.cellTitle.text = "History"
        }
        if(indexPath.row == 2){
            cell.cellTitle.text = "About & Help"
        }
        if(indexPath.row == 3){
            cell.cellTitle.text = "Invite Friends"
        }
        if(indexPath.row == 4){
            cell.cellTitle.text = "Log out"
        }

        return cell
    }
    

    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("WebSegue", sender: indexPath)
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
   

}
