//
//  myAccountViewController.swift
//  Provider
//
//  Created by imac on 27/09/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import WDImagePicker
class myAccountViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,WDImagePickerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var myDetials: myAccount? = nil
    var settingTable = UITableViewController()
    let serverDataProcess = ServiceDataProcess()
    var imagePicker: WDImagePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        let barButton = UIBarButtonItem()
//        let saveButton = UIButton()
//        saveButton.setTitle("Save", forState: .Normal)
//        barButton.customView = saveButton
//        barButton.enabled = false
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        
        self.navigationItem.backBarButtonItem = backItem
        self.navigationItem.title = "Account"
        
        settingTable.tableView.frame = CGRect(x: 12.5, y: 75, width: globalStyle.screenSize.width, height: globalStyle.screenSize.height)
        
        settingTable.tableView.delegate = self
        settingTable.tableView.dataSource = self
        settingTable.tableView.tableFooterView = UIView()
        settingTable.tableView.registerClass(MySettingCell.self, forCellReuseIdentifier: "myAccountSetting")
        
        self.view.addSubview(settingTable.tableView)
        
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(FBSDKAccessToken.currentAccessToken() != nil){
           return 4
            
        }
        return 5
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier("myAccountSetting", forIndexPath: indexPath) as? MySettingCell else {
            return UITableViewCell()
        }
        if(indexPath.row == 0){
            cell.cellTitle.text = ""
            cell.cellContent.text = myDetials?.myEmail
            cell.avatar.image = UIImage()
            
            if(self.myDetials?.userProfile != nil){
                //image.image = help.reSizeImage(scaledToSize: globalStyle.myProfileSize)
                serverDataProcess.retrieveCellImg(self.myDetials!.userProfile, image: cell.avatar, completion: {error in
                    if(error == nil){
                        
                        //avatarButton.setImage(image.image, forState:.Normal)
                    }
                    else{
                        cell.avatar.image = UIImage(named: "default")
                    }
                })
            }else{
                cell.avatar.image = UIImage(named: "default")
            }
        }
        
        if(indexPath.row == 1){
            cell.cellTitle.text = "Name"
            cell.cellContent.text = (myDetials?.userLastName)! + " " + (myDetials?.userFirstName)!
        }
        if(indexPath.row == 2){
            cell.cellTitle.text = "Address"
            let address = (myDetials?.ClientAddressStreet)! + " " + (myDetials?.ClientAddressSuburb)! + " " + (myDetials?.ClientAddressCity)!
            cell.cellContent.text = address
            
        }
        if(indexPath.row == 3){
            cell.cellTitle.text = "Phone"
            cell.cellContent.text = myDetials?.myPhone
        }
        
        
        if(FBSDKAccessToken.currentAccessToken() != nil){
            if(indexPath.row == 4){
                
                cell.cellTitle.text = "Change Password"
            }
            
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0){
            
        }
    }
}
