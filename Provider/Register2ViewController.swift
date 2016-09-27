//
//  Register2ViewController.swift
//  Provider
//
//  Created by imac on 30/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class Register2ViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    var inputCollection = [customUITextField]()
    let indicator = UIActivityIndicatorView()
    var lock = false
    var scrollView = UIScrollView()
    var activeField: UITextField?
    
    var topLabel:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 12.5, globalStyle.screenSize.width-25, 25)
        label.text = "* You can skip this step and fill it later"
        label.textAlignment = .Center
        label.textColor = globalStyle.subTitleColor2
        label.font = globalStyle.subTitleFontsize
        //        label.layer.borderWidth = 0.5
        //        label.layer.borderColor = globalStyle.subTitleColor4.CGColor
        //        label.layer.cornerRadius = 6.0
        return label
    }
    var descriptionLabel:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 50, globalStyle.screenSize.width-25, 25)
        label.text = "Skill description (Optional)"
        label.textAlignment = .Left
        label.textColor = globalStyle.subTitleColor4
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var company:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+50, 100, 50)
        label.text = "Company Name"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        
        return label
    }
    
    var street:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+100, 100, 50)
        label.text = "Street"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var suburb:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+150, 100, 50)
        label.text = "Suburb"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    var city:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+200, 100, 50)
        label.text = "City"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var licenseNum:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+250, 100, 50)
        label.text = "License Number"
        label.textAlignment = .Right
        label.textColor = globalStyle.subTitleColor
        label.font = globalStyle.subTitleFontsize
        return label
    }
    
    var registerSecondTabContainer:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 150+50, globalStyle.screenSize.width-25, 250)
        label.layer.borderWidth = 0.5
        label.layer.borderColor = globalStyle.subTitleColor4.CGColor
        label.layer.cornerRadius = 6.0
        return label
        
    }
    
    //    var imageUploaderTabContainer:UILabel{
    //        let label = UILabel()
    //        label.frame = CGRectMake(12.5, 450, globalStyle.screenSize.width-25, 100)
    //        label.layer.borderWidth = 0.5
    //        label.layer.borderColor = globalStyle.subTitleColor4.CGColor
    //        label.layer.cornerRadius = 6.0
    //        return label
    //
    //    }
    
    let companyInput = customUITextField(frame: CGRectMake(12.5, 150+50, globalStyle.screenSize.width-25, 50), placeholder: "Optional",boderNeeded: true)
    let streetInput = customUITextField(frame: CGRectMake(12.5, 150+100, globalStyle.screenSize.width-25, 50), placeholder: "Optional",boderNeeded: true)
    let suburbInput = customUITextField(frame: CGRectMake(12.5, 150+150, globalStyle.screenSize.width-25, 50), placeholder: "Optional",boderNeeded: true)
    let cityInput = customUITextField(frame: CGRectMake(12.5, 150+200, globalStyle.screenSize.width-25, 50), placeholder: "Optional",boderNeeded: true)
    let licenseNumInput = customUITextField(frame: CGRectMake(12.5, 150+250, globalStyle.screenSize.width-25, 50), placeholder: "Optional",boderNeeded: false)
    //let comfirmPassInput = customUITextField(frame: CGRectMake(12.5, 112.5+300, globalStyle.screenSize.width-25, 50), placeholder: "Repeat Your Password",boderNeeded: false)
    //var uploaderButton = UIButton(frame: CGRectMake(12.5, 450-12.5, (globalStyle.screenSize.width-25)/3, (globalStyle.screenSize.width-25)/3))
    
    
    var next = UIButton()
    var skillDescription = UITextView()
    
    override func viewWillAppear(animated: Bool) {
        self.scrollView.scrollEnabled = true;
        self.registerForKeyboardNotifications()
        //self.automaticallyAdjustsScrollViewInsets = true
    }
    override func viewWillDisappear(animated: Bool) {
        self.deregisterFromKeyboardNotifications()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Details"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        //self.hideKeyboardWhenTappedAround()
        
        //self.registerForKeyboardNotifications()
        self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        self.scrollView.scrollEnabled = true;
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        self.view.addSubview(scrollView)
        
        // Do any additional setup after loading the view.
        skillDescription.frame = CGRectMake(12.5,75, globalStyle.screenSize.width-25.0, 100)
        skillDescription.editable = true
        skillDescription.layer.borderWidth = 0.5
        skillDescription.layer.borderColor = globalStyle.subTitleColor4.CGColor
        skillDescription.layer.cornerRadius = 6.0
        
        next.frame = CGRectMake(0, globalStyle.screenSize.height-50, globalStyle.screenSize.width, 50)
        next.backgroundColor = globalStyle.backgroundColor
        next.tintColor = UIColor.whiteColor()
        next.titleLabel?.font = globalStyle.subTitleFontsize
        next.setTitle("Next Step", forState: UIControlState.Normal)
        next.addTarget(self, action: #selector(self.nextStep), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        skillDescription.delegate = self
        companyInput.delegate = self
        streetInput.delegate = self
        cityInput.delegate = self
        licenseNumInput.delegate = self
        
        companyInput.returnKeyType = .Done
        streetInput.returnKeyType = .Done
        cityInput.returnKeyType = .Done
        licenseNumInput.returnKeyType = .Done
        skillDescription.returnKeyType = .Done
        
        
        
        self.scrollView.addSubview(topLabel)
        self.scrollView.addSubview(descriptionLabel)
        self.scrollView.addSubview(company)
        self.scrollView.addSubview(street)
        self.scrollView.addSubview(city)
        self.scrollView.addSubview(suburb)
        self.scrollView.addSubview(licenseNum)
        self.scrollView.addSubview(registerSecondTabContainer)
        
        
        
        self.scrollView.addSubview(skillDescription)
        self.scrollView.addSubview(companyInput)
        self.scrollView.addSubview(streetInput)
        self.scrollView.addSubview(suburbInput)
        self.scrollView.addSubview(cityInput)
        self.scrollView.addSubview(licenseNumInput)
        
        
        self.view.addSubview(next)
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ThirdRegisterViewTable"{
            if let dest = segue.destinationViewController as? thirdRegViewController {
                inputCollection += [self.companyInput,self.streetInput,self.suburbInput,self.cityInput,self.licenseNumInput]
                dest.inputCollection = self.inputCollection
                dest.skillDescript = self.skillDescription.text
            }
        }
    }
    
    // MARK: function
    func nextStep(){
        self.performSegueWithIdentifier("ThirdRegisterViewTable", sender: self)
    }
    
    
    
    
    
    
    
    
    // MARK: Keyboard function
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        //        self.scrollView.scrollEnabled = true
        //        let info : NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size
        //        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        //
        //        self.scrollView.contentInset = contentInsets
        //        self.scrollView.scrollIndicatorInsets = contentInsets
        //        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 500);
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
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(75-12.5, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height+250.0);
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = true
        
        //        let contentInsets = UIEdgeInsetsZero
        //        self.scrollView.contentInset = contentInsets
        //        self.scrollView.scrollIndicatorInsets = contentInsets
        //        self.scrollView.scrollEnabled = true
        //        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField)
    {
        activeField = nil
    }
    
}
