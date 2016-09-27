//
//  RecentSearchTableViewController.swift
//  Provider
//
//  Created by imac on 15/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

protocol RecntSearchTableViewControllerDelegate:class {
    func didCellSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class RecentSearchTableViewController: UITableViewController {
    
    var recentSearchData = NSUserDefaults()
    var recordsdelegate:RecntSearchTableViewControllerDelegate?
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        //self.tableView.frame = CGRectMake(0, 25, globalStyle.screenSize.width, globalStyle.screenSize.height)
        self.tableView.rowHeight = 40.0
        self.tableView.separatorColor = globalStyle.bgColor1
        self.tableView.registerClass(logs.self, forCellReuseIdentifier: "recordid")
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 37.5, 0)
        self.tableView.tableFooterView = UIView()
        self.tableView.alpha = 0
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
        if let array = recentSearchData.valueForKey("userSearchLogs") as? [String]{
            print(array)
            return array.count
        }
        else{
            return 0
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        recordsdelegate?.didCellSelected(tableView,didSelectRowAtIndexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("recordid", forIndexPath: indexPath) as! logs
        
        // Configure the cell...
        var records = recentSearchData.valueForKey("userSearchLogs") as! [String]
        cell.record.text = records[indexPath.row]
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
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
class logs: UITableViewCell {
    
    var itemShown = false
    override init(style:UITableViewCellStyle,reuseIdentifier:String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemneted")
    }
    
    let record:UILabel = {
        let recordLabel = UILabel()
        recordLabel.font = globalStyle.dateTitleFont
        recordLabel.textColor = globalStyle.subTitleColor2
        recordLabel.translatesAutoresizingMaskIntoConstraints = false
        return recordLabel
    }()
    
    func setupViews(){
        addSubview(record)
        //auotlayout Username
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[r0(>=100)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["r0":record]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15.0-[r0(>=10)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["r0":record]))
    }
}
