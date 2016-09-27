//
//  RegisterViewController.swift
//  Provider
//
//  Created by imac on 28/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import ZHDropDownMenu
import Alamofire
import SwiftyJSON

class RegisterViewController: UIViewController,ZHDropDownMenuDelegate,UITextFieldDelegate {
    
    var alertLabel = UILabel(frame: CGRectMake(12.5, globalStyle.screenSize.height-95, globalStyle.screenSize.width-25, 50))
    var workType:String?
    let regBaseUrl = "http://para.co.nz/api/ProviderAccount/RegisterProvider"
    let checkUserExistedBaseUrl = "http://para.co.nz/api/ProviderAccount/CheckDuplicateUsername"
    let indicator = UIActivityIndicatorView()
    var scrollView = UIScrollView()
    var activeField: UITextField?
    var isFBLogin = false
    var inputCollection = [customUITextField]()
    //let userInfoDB = UserInfo()
    var skillsTypeBtn:UIButton{
        let button = UIButton()
        button.frame = CGRectMake(12.5, 100, globalStyle.screenSize.width-25.0, 50)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = globalStyle.subTitleColor4.CGColor
        //button.setTitle("dasdas", forState: UIControlState.Normal)
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(self.chooseType), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    var nextStep = UIButton()
    
    var skillType:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 12.5, 100, 50)
        label.text = "Work Type"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    var emailAddress:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+50, 100, 50)
        label.text = "Email Address"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        
        return label
    }
    
    var phoneNum:UILabel{
        let label = UILabel()
        if(isFBLogin){
            label.frame = CGRectMake(12.5, 25+50, 100, 50)
        }
        else{
            label.frame = CGRectMake(12.5, 25+100, 100, 50)
        }
        label.text = "Phone Number"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var firstName:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+150, 100, 50)
        label.text = "First Name"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    var lastName:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+200, 100, 50)
        label.text = "Last Name"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var password:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+250, 100, 50)
        label.text = "Password"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var confirmPass:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+300, 100, 50)
        label.text = "Repeat Password"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var registerFisrtTabContainer:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 25+50, globalStyle.screenSize.width-25, 300)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = globalStyle.subTitleColor4.CGColor
        label.layer.cornerRadius = 6.0
        if(isFBLogin){
            label.frame = CGRectMake(12.5, 25+50, globalStyle.screenSize.width-25, 50)
        }
        return label
        
    }
    
    let emailInput = customUITextField(frame: CGRectMake(12.5, 25+50, globalStyle.screenSize.width-25, 50), placeholder: "Email@example.com",boderNeeded: true)
    let phoneInput =  customUITextField(frame: CGRectMake(12.5, 25+100, globalStyle.screenSize.width-25, 50), placeholder: "At least 7 Numbers",boderNeeded: false)
    let firstNameInput = customUITextField(frame: CGRectMake(12.5, 25+150, globalStyle.screenSize.width-25, 50), placeholder: "Your First Name",boderNeeded: true)
    let lastNameInput = customUITextField(frame: CGRectMake(12.5, 25+200, globalStyle.screenSize.width-25, 50), placeholder: "Your Last Name",boderNeeded: true)
    let passInput = customUITextField(frame: CGRectMake(12.5, 25+250, globalStyle.screenSize.width-25, 50), placeholder: "At least 6 characters",boderNeeded: true)
    let comfirmPassInput = customUITextField(frame: CGRectMake(12.5, 25+300, globalStyle.screenSize.width-25, 50), placeholder: "Repeat Your Password",boderNeeded: false)
    var avatar_url = ""
    
    
    let dropMenu = ZHDropDownMenu()
    
    var lock = false
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    override func viewWillAppear(animated: Bool) {
        //self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.scrollEnabled = true
        self.registerForKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 450)
        scrollView.scrollEnabled = true;
        scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 375);
        self.view.addSubview(scrollView)
        //registerForKeyboardNotifications()
        
        //self.hideKeyboardWhenTappedAround()
        
        alertLabel.alpha = 0.0;
        alertLabel.textAlignment = .Center
        alertLabel.textColor = globalStyle.alertColor
        alertLabel.font = globalStyle.subTitleFontsize
        
        indicator.color = globalStyle.subTitleColor3
        indicator.frame = CGRectMake(12.5, globalStyle.screenSize.height-95, globalStyle.screenSize.width-25, 50)
        
        //self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.title = "Registration"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        // Do any additional setup after loading the view.
        //scrollView.addSubview(skillType)
        if(isFBLogin == false){
            scrollView.addSubview(emailAddress)
            scrollView.addSubview(firstName)
            scrollView.addSubview(lastName)
            scrollView.addSubview(password)
            scrollView.addSubview(confirmPass)
            self.scrollView.addSubview(firstNameInput)
            self.scrollView.addSubview(lastNameInput)
            self.scrollView.addSubview(passInput)
            self.scrollView.addSubview(comfirmPassInput)
            scrollView.addSubview(emailInput)
            phoneInput.layer.addBorder(.Bottom, color: globalStyle.subTitleColor4, thickness: 0.5)
        }
        else{
            phoneInput.frame = CGRectMake(12.5, 25+50, globalStyle.screenSize.width-25, 50)
        }
        scrollView.addSubview(phoneNum)
        
        
        
        self.view.addSubview(alertLabel)
        
        passInput.secureTextEntry = true
        comfirmPassInput.secureTextEntry = true
        
        passInput.delegate = self
        emailInput.delegate = self
        phoneInput.delegate = self
        firstNameInput.delegate = self
        lastNameInput.delegate = self
        comfirmPassInput.delegate = self
        
        passInput.returnKeyType = .Done
        comfirmPassInput.returnKeyType = .Done
        emailInput.returnKeyType = .Done
        phoneInput.returnKeyType = .Done
        firstNameInput.returnKeyType = .Done
        lastNameInput.returnKeyType = .Done
        
        emailInput.keyboardType = .EmailAddress
        //phoneInput.keyboardType = .NumberPad
        firstNameInput.keyboardType = .NamePhonePad
        lastNameInput.keyboardType = .NamePhonePad
        
       
        scrollView.addSubview(phoneInput)

        
        dropMenu.frame = CGRectMake(12.5, 12.5, globalStyle.screenSize.width-25.0, 50)
        dropMenu.round(UIRectCorner.TopLeft.union(.TopRight), radius: 6.0, borderColor: globalStyle.subTitleColor4, borderWidth: 0.5)
        dropMenu.placeholder = "Choose Your Skills"
        dropMenu.options = ["Plumber","Electracian","Woodworker","Builder","Painter","Others"] //设置下拉列表项数据
        dropMenu.editable = false //禁止编辑
        dropMenu.delegate = self
        dropMenu.font = globalStyle.subTitleFontsize
        dropMenu.textColor = globalStyle.subTitleColor
        self.scrollView.addSubview(dropMenu)
        
        self.scrollView.addSubview(registerFisrtTabContainer)
        
        
        nextStep.frame = CGRectMake(0, self.view.bounds.size.height-50, globalStyle.screenSize.width, 50)
        nextStep.backgroundColor = globalStyle.backgroundColor
        nextStep.tintColor = UIColor.whiteColor()
        nextStep.titleLabel?.font = globalStyle.subTitleFontsize
        nextStep.setTitle("Next Step", forState: UIControlState.Normal)
        nextStep.addTarget(self, action: #selector(self.nextRegist), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(nextStep)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func chooseType(sender:UIButton)  {
        
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        //        self.scrollView.scrollEnabled = true
        //        let info : NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        //        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        //
        //        self.scrollView.contentInset = contentInsets
        //        self.scrollView.scrollIndicatorInsets = contentInsets
        //
        //        var aRect : CGRect = self.view.frame
        //        aRect.size.height -= keyboardSize!.height
        //        if activeField != nil
        //        {
        //            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
        //            {
        //                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
        //            }
        //        }
        if let activeField = self.activeField, keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!CGRectContainsPoint(aRect, activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        //        let info : NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        //        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(75, 0.0, -keyboardSize!.height, 0.0)
        //        self.scrollView.contentInset = contentInsets
        //        self.scrollView.scrollIndicatorInsets = contentInsets
        //        self.view.endEditing(true)
        //        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets = UIEdgeInsets(top: 75.0-12.5, left: 0.0, bottom: -keyboardSize!.height, right: 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+10.0);
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.scrollEnabled = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
    func nextRegist(){
        
        let inputsField = [self.emailInput, self.phoneInput, self.firstNameInput, self.lastNameInput, self.passInput,self.comfirmPassInput]
        for value in inputsField{
            //value.layer.addBorder(.Bottom, color: globalStyle.subTitleColor4, thickness: 0.5)
            
            if(help.isValidLength(value.text!) == false){
                alertLabel.alpha = 1.0
                alertLabel.text = "Your Input Characters Were too long"
                alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
                if(value.placeholder != "Repeat Your Password"){
                        value.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
                }
                return
            }
            else if(value.placeholder != "Repeat Your Password"){
                if(isFBLogin == false){
                    value.layer.addBorder(.Bottom, color: globalStyle.subTitleColor4, thickness: 0.5)
                }
            }
        }
        
        
        if(self.isFBLogin == false){
            if((self.workType) == nil)||(self.emailInput.text == "" || self.phoneInput.text == "" || self.firstNameInput.text == "" || self.lastNameInput.text == "" || self.passInput.text == "" || self.comfirmPassInput.text == ""){
                alertLabel.alpha = 1.0
                alertLabel.text = "All fields are required"
                alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
                return
            }
        }
        else if(self.isFBLogin == true){
            if((self.workType) == nil)||(self.phoneInput.text == ""){
                alertLabel.alpha = 1.0
                alertLabel.text = "All fields are required"
                alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
                return
            }
        }
        
        if(help.isValidEmail(self.emailInput.text!) == false && self.isFBLogin == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "Please Type Correct Email Format"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            emailInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            return
        }
        else if(help.isValidPhoneNumber(self.phoneInput.text!) == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "Pleas Type correct Phone Number"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            phoneInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            
            return
        }
        else if(help.isValidLength(self.firstNameInput.text!) == false && self.isFBLogin == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "Your input characters were too long"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            firstNameInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            
            return
        }
        else if(help.isValidLength(self.lastNameInput.text!) == false && self.isFBLogin == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "Your input characters were too long"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            lastNameInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            
            return
        }
        else if(help.isValidPassword(self.passInput.text!) == false && self.isFBLogin == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "password must be between 6 and 10 characters and contain at least 1 number and 1 Alphabet"
            alertLabel.numberOfLines = 0;
            
            alertLabel.lineBreakMode = .ByWordWrapping
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            passInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            
            return
        }
        else if(self.passInput.text! != self.comfirmPassInput.text! && self.isFBLogin == false){
            alertLabel.alpha = 1.0
            alertLabel.text = "Password does not match the confirm password"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            passInput.layer.addBorder(.Bottom, color: globalStyle.alertColor, thickness: 0.5)
            return
        }
        else{
            alertLabel.alpha = 0.0
            self.inputCollection = inputsField
            self.indicator.startAnimating()
            if(lock == false){
                self.lock = true
                //check user name exist
            
                print(self.emailInput.text)
                Alamofire.request(.POST, self.checkUserExistedBaseUrl,parameters: ["username": self.emailInput.text!]).validate().responseJSON{response in
                    switch response.result {
                    case .Success(let data):
                        let json = JSON(data)
                        if(json == true){//Username existed
                            self.indicator.stopAnimating()
                            self.alertLabel.alpha = 1.0
                            self.alertLabel.text = "User Name Were Already Registerted"
                            self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                            self.lock = false
                        }
                        else if (json == false){
                            self.indicator.stopAnimating()
                            //post regist info
                            
                            //self.performSegueWithIdentifier("SecondRegisterViewTable", sender: self)
                            let regInfo:[String: AnyObject] = [
                                "username":self.emailInput.text!,
                                "password":self.passInput.text!,
                                "CellPhone":self.phoneInput.text!,
                                "firstName":self.firstNameInput.text!,
                                "type":self.workType!,
                                "lastName" : self.lastNameInput.text!]

                            
                            
                            
                            Alamofire.request(.POST,self.regBaseUrl,parameters: regInfo , encoding: .JSON).validate().responseJSON{response in
                                switch response.result {
                                case .Success(let data):
                                    let json = JSON(data)
                                    if(json == true){
                                        self.indicator.stopAnimating()
                                        let data = UserInfo(value: ["userName": self.emailInput.text!, "createdAt": NSDate(),"lastName":self.lastNameInput.text!,"firstName":self.firstNameInput.text!,"phoneNumber":self.phoneInput.text!,"workType":self.workType!,"avatar":self.avatar_url,])
                                        try! uiRealm.write {
                                            uiRealm.add(data)
                                        }
                                        let activeUser = NSUserDefaults.standardUserDefaults()
                                        activeUser.setObject(self.emailInput.text!, forKey: "ActiveUser")
//                                        let registerController2 = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterView2") as! Register2ViewController
//                                        self.navigationController!.pushViewController(registerController2, animated: true)
                                            let tabBarController = self.storyboard!.instantiateViewControllerWithIdentifier("tabBarView") as! CustomUITabBarController
                                            let appDelgate = UIApplication.sharedApplication().delegate as! AppDelegate
                                            appDelgate.window?.rootViewController = tabBarController
                                    }
                                    else if (json == false){
                                        self.indicator.stopAnimating()
                                        self.alertLabel.alpha = 1.0
                                        self.alertLabel.text = "Server Error Please Contact Our Administrator"
                                        self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                                    }
                                case .Failure(let error):
                                    self.indicator.stopAnimating()
                                    self.alertLabel.alpha = 1.0
                                    self.alertLabel.text = String(error)
                                    self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                                    print("Network Request failed with error: \(error)")
                                }
                                self.lock = false
                            }
                        }
                        
                    case .Failure(let error):
                        self.indicator.stopAnimating()
                        self.alertLabel.alpha = 1.0
                        self.alertLabel.text = String(error)
                        self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                        print("Network Request failed with error: \(error)")
                        self.lock = false
                    }
                    self.lock = false
                }
                
            }
        }
    }
    func dropDownMenu(menu: ZHDropDownMenu!, didChoose index: Int) {
        self.workType = menu.options[index]
        //print("\(menu.options[index]) choosed at index \(index)")
    }
    
    //编辑完成后回调
    func dropDownMenu(menu: ZHDropDownMenu!, didInput text: String!) {
        print("\(menu) input text \(text)")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //        if (textField == emailInput){
        //            // Found next responder, so set it.
        //            phoneInput.becomeFirstResponder()
        //        }
        //        else if (textField == phoneInput){
        //            // Found next responder, so set it.
        //            firstNameInput.becomeFirstResponder()
        //        }
        //        else if (textField == firstNameInput){
        //            // Found next responder, so set it.
        //            lastNameInput.becomeFirstResponder()
        //        }
        //        else if (textField == lastNameInput){
        //            // Found next responder, so set it.
        //            passInput.becomeFirstResponder()
        //        }
        //        else if (textField == passInput){
        //            // Found next responder, so set it.
        //            comfirmPassInput.becomeFirstResponder()
        //        }
        //        else if (textField == comfirmPassInput){
        //            self.nextStep.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        //        }
        //        else
        //        {
        //            // Not found, so remove keyboard
        //            textField.resignFirstResponder()
        //        }
        self.view.endEditing(true)
        return false
    }
    
    
    
    /*
     // MARK: - Navigation
     
     
     
     
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SecondRegisterViewTable"{
            if let dest = segue.destinationViewController as? Register2ViewController {
                dest.inputCollection = self.inputCollection
            }
        }
    }
    
    
}

class customUITextField:UITextField{
    
    var placeholderText:String?
    //var sortViewBorder:UIView
    
    init(frame: CGRect,placeholder: String,boderNeeded:Bool) {
        super.init(frame: frame)
        self.placeholderText = placeholder
        self.placeholder = placeholder
        self.font = globalStyle.subTitleFontsize
        if(boderNeeded){
            self.layer.addBorder(.Bottom, color: globalStyle.subTitleColor4, thickness: 0.5)
        }
        //self.returnKeyType = UIReturnKeyDone
    }

    
    override func placeholderRectForBounds(bounds: CGRect) -> CGRect {
        let inset:CGRect = CGRectMake(bounds.origin.x+120, bounds.origin.y, bounds.size.width, 50);
        return inset;
    }
    
    override func leftViewRectForBounds(bounds: CGRect) -> CGRect {
        let inset = CGRectMake(bounds.origin.x+120, bounds.origin.y, 120, 50);
        return inset;
    }
    
    override func textRectForBounds(bounds:CGRect) -> CGRect
    {
        //return CGRectInset(bounds, 50, 0);
        let inset:CGRect = CGRectMake(bounds.origin.x+120, bounds.origin.y, bounds.size.width, bounds.size.height);
        return inset;
        
    }
    
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        let inset:CGRect = CGRectMake(120, bounds.origin.y, bounds.size.width,50);
        return inset;
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWasShown(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RegisterViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}

extension UIView {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor;
    }
    
}

private extension UIView {
    
    func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clearColor().CGColor
        borderLayer.strokeColor = borderColor.CGColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
    
}
