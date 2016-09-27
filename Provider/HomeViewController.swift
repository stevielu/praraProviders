//
//  HomeViewController.swift
//  Provider
//
//  Created by imac on 1/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import SwiftR
class HomeViewController: CustomNavgationbarItemsViewController,UISearchBarDelegate,UISearchResultsUpdating, CustomSearchControllerDelegate,RecntSearchTableViewControllerDelegate,cellButtonDelegate
{
    
    
    var searchBarController = UISearchController(searchResultsController:nil);
    var customSearchController: CustomSearchControllerViewController!
    var providerTable = CustomTableViewController()
    let recentTapView = myLabelStyle1(frame: CGRect(x: 0, y: -25, width: globalStyle.screenSize.width, height: 25))
    let searchTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -40, 0)
    let searchTransformsearchTape = CATransform3DTranslate(CATransform3DIdentity, 0, 25, 0)
    let searchTransformSortContainer = CATransform3DTranslate(CATransform3DIdentity, 0, -50, 0)
    //locate elements
    let sortViewContainer = myLabelStyle2(frame:CGRect(x: 0, y: 0, width: globalStyle.screenSize.width, height: 50))
    let sortByTypeButton = UIButton(frame: CGRect(x: 0, y: 10, width: globalStyle.screenSize.width/3, height: 30))
    let sortByDateButton = UIButton(frame: CGRect(x: globalStyle.screenSize.width/3, y: 10, width: globalStyle.screenSize.width/3, height: 30))
    let sortByLocationButton = UIButton(frame: CGRect(x: (globalStyle.screenSize.width/3)*2, y: 10, width: globalStyle.screenSize.width/3, height: 30))
    
    let searchRecords = RecentSearchTableViewController()
    var sortViewBorder:UIView?
    //chat details
    var chatDetails = ConversationList(name: "", email: "", avatar: UIImageView.init(image: UIImage(named: "default.png")), latestMessage: "")
    let chat = SignalRChat()
    
    
    var lock = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        providerTable.btnDelegate = self
        self.view.backgroundColor = UIColor.whiteColor()
        searchRecords.recordsdelegate = self
        providerTable.tableView.frame = CGRect(x: 0, y: 50, width: globalStyle.screenSize.width, height: globalStyle.screenSize.height)
        searchRecords.tableView.frame = CGRect(x: 0, y: 25, width: globalStyle.screenSize.width, height: globalStyle.screenSize.height)
        self.view.addSubview(providerTable.tableView)
        self.view.addSubview(searchRecords.tableView)
        setupSortView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }
    
   
    override func viewWillAppear(animated: Bool) {
//        let subUnreads = self.chat.getAllUnreads()
//        self.tabBarItem.badgeValue = String(subUnreads)
        configureCustomSearchController()
        customSearchController.customSearchBar.sizeToFit()
        self.navigationItem.titleView = customSearchController.customSearchBar
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator)
    {
//        dispatch_async(dispatch_get_main_queue()) {
//            print(size.width)
//            self.sortViewContainer.frame = CGRectMake(0, 0, size.width, 25)
//            //self.sortViewContainer.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: globalStyle.thickness)
//            self.sortByTypeButton.frame = CGRectMake(0, 0, size.width/3, 25)
//            self.sortByDateButton.frame = CGRectMake(size.width/3, 0, globalStyle.screenSize.width/3, 25)
//            self.sortByLocationButton.frame = CGRectMake((size.width/3)*2, 0, globalStyle.screenSize.width/3, 25)
//        }
    }
    

//    // MARK: UITableView Delegate and Datasource functions
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if shouldShowSearchResults {
//            return filteredRestults.count
//        }
//        else {
//            return providerTable.providersArray.count
//        }
//    }
//    
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cellId", forIndexPath: indexPath)
//        
//        if shouldShowSearchResults {
//            
//        }
//        return cell
//    }
//    
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 75.0
//    }
    
    func didPressChatButton(sender:myButton){
        self.performSegueWithIdentifier( "toChat1", sender: sender)
    }
    
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let conversationController = segue.destinationViewController as? ChatViewController {
            
            
            if let data = self.providerTable.shareData{
                //conversationController.clientDetials?.userLastName = data.clientName!
                conversationController.clientDetials.senderEmail = data.clientEmail!
                conversationController.clientDetials.userProfile = data.profilePhoto!
                //self.providerTable.serverDataProcess.retrieveCellImg("http://para.co.nz/api/ClientProfile/GetClientProfileImage/"+data.profilePhoto!, image: self.chatDetails.avatar)
                //conversationController.clientDetials = self.chatDetails
            }
            conversationController.hidesBottomBarWhenPushed = true
        }
    }
    
    
    
    
    
    
    
    
//    func createSearchbar(){
//        searchBarController.searchResultsUpdater = self
//        searchBarController.dimsBackgroundDuringPresentation = false
//        searchBarController.hidesNavigationBarDuringPresentation = false
//        searchBarController.searchBar.tintColor = UIColor.whiteColor()
//        searchBarController.searchBar.placeholder = "Type in any key words"
//        self.definesPresentationContext = true
//        
//        
//        
//        self.navigationItem.titleView = searchBarController.searchBar
//    }
    
    func setupSortView(){
        
        //load buttom images
        defaultSortButtonView()
        self.sortViewBorder = addHorizantalLine(lineStart:CGPoint(x:0,y:50),lineEnd:CGPoint(x:globalStyle.screenSize.width,y:50))
            sortViewBorder?.backgroundColor = globalStyle.backgroundColor
            self.view.addSubview(sortViewBorder!)
        
        //add sort container
        sortViewContainer.backgroundColor =  UIColor.whiteColor()
        //sortViewContainer.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: globalStyle.thickness)
        self.view.addSubview(sortViewContainer)
        
        //add button
        sortByTypeButton.addTarget(self, action: #selector(self.sortBytype), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(sortByTypeButton)
        
        sortByDateButton.addTarget(self, action: #selector(self.sortBydate), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(sortByDateButton)
        
        sortByLocationButton.addTarget(self, action: #selector(self.sortBylocation), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(sortByLocationButton)
        
        
        //sortViewContainer.frame = CGRectMake(12.5, 0, globalStyle.screenSize.width, 25)//= UILabel(frame: CGRectMake(12.5, 0, globalStyle.screenSize.width, 25))
        //sortViewContainer.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: globalStyle.thickness)
    }
    
    func recentSearchTap(){
        //create recent search tap
        //let recentTapView = CustomNavgationbarItemsViewController(CGRect(0,0,25,100))
        
        
        recentTapView.textAlignment = NSTextAlignment.Left
        recentTapView.text = "Recent search:"
        recentTapView.textColor = globalStyle.subTitleColor
        recentTapView.font = globalStyle.subTitleFontsize
        recentTapView.backgroundColor = UIColor.whiteColor()
        
//        if(providerTable.shouldShowSearchResults){
//            recentTapView.alpha = 1
//        }
//        else{
//            recentTapView.alpha = 0
//        }
        //addRecentSearchBottomBorder()
        recentTapView.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.bgColor1, thickness: globalStyle.thickness)
        self.view.addSubview(recentTapView)
        
    }
    
    func addRecentSearchBottomBorder(){
        let border = UILabel(frame: CGRectMake(0, 0, globalStyle.screenSize.width, 25))
        border.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: globalStyle.thickness)
        self.view.addSubview(border)
    }
    
    func defaultSortButtonView(){
        cellBtnMoveBack()
        sortByTypeButton.setImage(iconLists.imgBtnType, forState: UIControlState.Normal)
        sortByTypeButton.layer.addBorder(UIRectEdge.Right, color: globalStyle.backgroundColor, thickness: 0.5)
        sortByTypeButton.enabled = true
        
        sortByDateButton.setImage(iconLists.imgBtnDate, forState: UIControlState.Normal)
        sortByDateButton.layer.addBorder(UIRectEdge.Right, color: globalStyle.backgroundColor, thickness: 0.5)
        sortByDateButton.enabled = true
        
        sortByLocationButton.setImage(iconLists.imgBtnLocation, forState: UIControlState.Normal)
        sortByLocationButton.enabled = true
    }
    
    
    func sortAnimation(){
        
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, globalStyle.screenSize.width, 0, 0)
        
        for (var i=0;i<providerTable.tableView.visibleCells.count;i += 1){
            providerTable.tableView.visibleCells[i].layer.transform = rotationTransform
            UIView.animateWithDuration(0.6, delay: Double(i)*0.05, options: .CurveEaseOut, animations: {() -> Void in
                self.providerTable.tableView.visibleCells[i].layer.transform = CATransform3DIdentity
                }, completion: nil)
    }
       


//        let transition:CATransition = CATransition()
//        transition.type = kCATransitionMoveIn
//        transition.subtype = kCATransitionFromRight
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.duration = 0.6;
//        transition.fillMode = kCAFillModeForwards;
        
//        let cell = providerTable.tableView.visibleCells.
//        help.animateCell(cell, withTransform: help.TransformWave, andDuration: 1)
        //let cells = providerTable.tableView.visibleCells
        
//        for cell in providerTable.tableView.visibleCells {
//            UIView.animateWithDuration(1.0, animations: {() -> Void in
//                cell.alpha = 0.0
//                providerTable.tableView.visibleCells.
//            })
//            //cell.layer.addAnimation(transition, forKey: "UITableViewReloadDataAnimationKey")
//        }
        //providerTable.tableView.layer.addAnimation(transition, forKey: "UITableViewReloadDataAnimationKey")
    }
    
    func cellBtnMoveBack(){
        if let selection:NSIndexPath = providerTable.tableView.indexPathForSelectedRow{
            if let cell = providerTable.tableView.cellForRowAtIndexPath(selection) as? ServiceJobCell{
                UIView.animateWithDuration(0.6, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
                    self.providerTable.cellAnimatorMoveIn(cell)
                    cell.workType.alpha = 1
                    cell.subTitle.alpha = 1
                    cell.postDate.textColor = globalStyle.subTitleColor2
                    }, completion: nil)
            }
        }
    }
    
    func searchAnimationMoveUp(){
        

        sortByTypeButton.layer.transform = CATransform3DIdentity
        sortByDateButton.layer.transform = CATransform3DIdentity
        sortByLocationButton.layer.transform = CATransform3DIdentity
        
        recentTapView.layer.transform = CATransform3DIdentity
        sortViewContainer.layer.transform = CATransform3DIdentity
        
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.sortByTypeButton.layer.transform = self.searchTransform
            self.sortByDateButton.layer.transform = self.searchTransform
            self.sortByLocationButton.layer.transform = self.searchTransform
            
            self.recentTapView.layer.transform = self.searchTransformsearchTape
            self.sortViewContainer.layer.transform = self.searchTransformSortContainer
            }, completion: nil)
    }
    
    func searchAnimationMoveDown(){
        sortByTypeButton.layer.transform = searchTransform
        sortByDateButton.layer.transform = searchTransform
        sortByLocationButton.layer.transform = searchTransform
        
        recentTapView.layer.transform = searchTransformsearchTape
        sortViewContainer.layer.transform = searchTransformSortContainer
        
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.sortByTypeButton.layer.transform = CATransform3DIdentity
            self.sortByDateButton.layer.transform = CATransform3DIdentity
            self.sortByLocationButton.layer.transform = CATransform3DIdentity
            
            self.recentTapView.layer.transform = CATransform3DIdentity
            self.sortViewContainer.layer.transform = CATransform3DIdentity
            }, completion: nil)
        sortViewBorder?.backgroundColor = globalStyle.backgroundColor
    }
    
    func recentSearchAnimatorUp(){
        sortViewContainer.backgroundColor = UIColor.whiteColor()
        recentTapView.layer.transform = searchTransformsearchTape
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.recentTapView.layer.transform = CATransform3DIdentity
            }, completion: nil)
        sortViewBorder?.backgroundColor = UIColor.clearColor()
    }
    
    func recentSearchAnimatorDown(){
        sortViewContainer.backgroundColor = UIColor.whiteColor()
        recentTapView.layer.transform = CATransform3DIdentity
        UIView.animateWithDuration(0.15, delay: 0, options: .CurveEaseOut, animations: {() -> Void in
            self.recentTapView.layer.transform = self.searchTransformsearchTape
            }, completion: nil)
        sortViewBorder?.backgroundColor = UIColor.clearColor()
    }
    
    func sortBytype(){
        defaultSortButtonView()
        sortByTypeButton.setImage(iconLists.imgBtnTypePressed, forState: UIControlState.Normal)
        
        providerTable.providersArray = providerTable.providersArray.sort({(t1:JobServiceAttr,t2:JobServiceAttr) -> Bool in
            return t1.type!.characters.count > t2.type!.characters.count
        })
        
        
        providerTable.tableView.reloadData()
        sortAnimation()
        sortByTypeButton.enabled = false
        sortByTypeButton.adjustsImageWhenDisabled = false
    }
    
    func sortBydate(){
        defaultSortButtonView()
        sortByDateButton.setImage(iconLists.imgBtnDatePressed, forState: UIControlState.Normal)
        providerTable.providersArray = providerTable.providersArray.sort({(d1:JobServiceAttr,d2:JobServiceAttr) -> Bool in
            if(d1.createDate==d2.createDate){
                return false
            }
            if(d1.createDate!.earlierDate(d2.createDate!)==d1.createDate!){
                return false
            }
            return true
        })
        
        providerTable.tableView.reloadData()
        sortAnimation()
        sortByDateButton.enabled = false
        sortByDateButton.adjustsImageWhenDisabled = false
        
        
    }
    
    func sortBylocation(){
        defaultSortButtonView()
        sortByLocationButton.setImage(iconLists.imgBtnLocationPressed, forState: UIControlState.Normal)
        
    }
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchControllerViewController(searchResultsController: self, searchBarFrame: CGRectMake(0.0, 0.0, globalStyle.screenSize.width, 25.0), searchBarFont: globalStyle.subTitleFontsize!, searchBarTextColor: globalStyle.subTitleColor, searchBarTintColor: UIColor.whiteColor(),searchbarHeight:25.0)
        
        customSearchController.customSearchBar.placeholder = "Type in any key words"
        customSearchController.searchResultsUpdater = self
        customSearchController.dimsBackgroundDuringPresentation = false
        customSearchController.hidesNavigationBarDuringPresentation = false
        customSearchController.customSearchBar.showsCancelButton = false
        customSearchController.customSearchBar.sizeToFit()
        self.definesPresentationContext = true
        
        customSearchController.customDelegate = self
    }
    
    
    
    
    // MARK: Records Table view delegate function
    func didCellSelected(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! logs
        let searchText = cell.record.text
        customSearchController.customSearchBar.text = searchText
        lock = false
        didChangeSearchText(searchText!)
        
        //customSearchController.searchBar(customSearchController.customSearchBar, textDidChange: searchText!)
    }
    
    
    // MARK: UISearchResultsUpdating delegate function
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        cellBtnMoveBack()
        guard let searchString = searchController.searchBar.text else {
            return
        }
        sortViewContainer.backgroundColor =  UIColor.whiteColor()
        // Filter the data array and get only those countries that match the search text.
        let ret:[JobServiceAttr] = providerTable.providersArray.filter({
            $0.clientName == searchString
        })
        providerTable.filteredRestults  = ret
        // Reload the tableview.
        providerTable.tableView.reloadData()
        
    }
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        sortViewContainer.backgroundColor =  UIColor.whiteColor()
        cellBtnMoveBack()
        customSearchController.customSearchBar.showsScopeBar = true

        customSearchController.customSearchBar.sizeThatFits(CGSize(width: 200, height: 25))
        customSearchController.customSearchBar.setShowsCancelButton(true, animated: true)
        
        self.navigationItem.titleView = customSearchController.customSearchBar
        self.navigationItem.leftBarButtonItem = nil
        recentSearchTap()
        searchAnimationMoveUp()
        providerTable.shouldShowSearchResults = true
        providerTable.cellDidSelected = false
        providerTable.filteredRestults.removeAll()
        providerTable.tableView.reloadData()
        searchRecords.tableView.alpha = 1
        sortViewBorder?.backgroundColor = UIColor.clearColor()
        
    }
    
    
    func didTapOnSearchButton(searchBar: UISearchBar) {
        sortViewContainer.backgroundColor =  UIColor.whiteColor()
        cellBtnMoveBack()
        if((searchBar.text) != nil){
            if var value = providerTable.userSearchRecords.valueForKey("userSearchLogs") as? [String]{
                if(value.count >= 10){
                    value.removeLast()
                }
                
                if let existedIndex = value.indexOf(searchBar.text!){
                    value.removeAtIndex(existedIndex)
                }
                
                value.insert(searchBar.text!, atIndex: 0)
                providerTable.userSearchRecords.setObject(value as NSArray, forKey: "userSearchLogs")
            }
            else{
                var logs = [String]()
                logs.insert(searchBar.text!, atIndex: 0)
                providerTable.userSearchRecords.setObject(logs as NSArray, forKey: "userSearchLogs")

            }
            providerTable.userSearchRecords.synchronize()
            searchRecords.tableView.reloadData()
//            searchRecords.tableView.alpha = 0
//            providerTable.tableView.alpha = 1
//            searchAnimationMoveUp()
        }
        
    }
    
    
    func didTapOnCancelButton() {
        sortViewContainer.backgroundColor =  UIColor.whiteColor()
        cellBtnMoveBack()
        customSearchController.customSearchBar.showsScopeBar = false
        customSearchController.customSearchBar.sizeThatFits(CGSize(width: 280, height: 25))
        customSearchController.customSearchBar.setShowsCancelButton(false, animated: true)
        customSearchController.customSearchBar.text = ""
        self.navigationItem.titleView = customSearchController.customSearchBar
        self.navigationItem.leftBarButtonItem =  UIBarButtonItem(customView: self.homeBtn)
        providerTable.shouldShowSearchResults = false
        providerTable.tableView.reloadData()
        sortAnimation()
        searchAnimationMoveDown()
        searchRecords.tableView.alpha = 0
    }
    
    
    func didChangeSearchText(searchText: String) {
        cellBtnMoveBack()
        providerTable.cellDidSelected = false
        providerTable.shouldShowSearchResults = true
        
        let ret:[JobServiceAttr] = providerTable.providersArray.filter({ filter in
            filter.clientName!.uppercaseString.containsString(searchText.uppercaseString)||filter.title!.uppercaseString.containsString(searchText.uppercaseString)

        })

        providerTable.filteredRestults = ret
        print(ret.count)
        // Reload the tableview.
        providerTable.tableView.reloadData()
        
        if(searchText.characters.count > 0){
            if(lock == false){
                searchRecords.tableView.alpha = 0
                recentSearchAnimatorUp()
                lock = true
            }
        }
        else{
            if(lock == true){
                lock = false
                searchRecords.tableView.alpha = 1
                recentSearchAnimatorDown()
            }
            
        }
        
        
    }
    
//    override func prefersStatusBarHidden() ->Bool
//    {
//        return true;
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//extension HomeViewController:UISearchResultsUpdating{
//    
//    func updateSearchResultsForSearchController(searchController: UISearchController){
//        recentSearchTap()
//    }
//}

class myLabelStyle1:UILabel{
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 12.5, bottom: 0, right: 5)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
}
class myLabelStyle2:UILabel{
    override func drawTextInRect(rect: CGRect) {
        let insets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
        self.backgroundColor = UIColor.whiteColor()
    }
}
