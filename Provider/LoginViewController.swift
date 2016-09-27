//
//  LoginViewController.swift
//  Provider
//
//  Created by imac on 26/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SnapKit

class LoginViewController: UIViewController,UITextFieldDelegate,FBSDKLoginButtonDelegate {
    let userNameInput = UITextField(frame: CGRectMake(12.5, 180+25, globalStyle.screenSize.width-25, 50))
    let userPassInput = UITextField(frame: CGRectMake(12.5, 230+25, globalStyle.screenSize.width-25, 50))
    var alertLabel = UILabel(frame: CGRectMake(12.5, 280+25, globalStyle.screenSize.width-25, 25))
    //var line = UIView()//frame: CGRectMake(12.5, 380+25, 10, 25)
    var orText = UILabel()
    let loginBaseUrl = "http://para.co.nz/api/ProviderAccount/ValidateAccount"
    let checkUserExistedBaseUrl = "http://para.co.nz/api/ProviderAccount/CheckDuplicateUsername"
    let indicator = UIActivityIndicatorView()
    var lock = false
    var dataFetch = ServiceDataProcess()
    
    
//    
    var line:UIView{
        let aline = UIView()
        aline.frame = CGRectMake(12.5, 405+30, globalStyle.screenSize.width-25, 0.5)
        //aline = addHorizantalLine(lineStart:CGPoint(x:0,y:405),lineEnd:CGPoint(x:1,y:405))
        aline.backgroundColor = globalStyle.subTitleColor4

        return aline
    }
    
    var logo:UIImageView{
        let logo = UIImageView(image: UIImage(named: "provider_logo")!)
        logo.frame = CGRect(x: globalStyle.screenSize.width/2 - 107, y: 50, width: 214, height: 150)
        return logo
    }
    
    var emailLabel:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(25, 180+25, 100, 50)
        label.text = "Email Address"
        label.textAlignment = .Right
        label.textColor = globalStyle.backgroundColor
        label.font = globalStyle.nameTitleFont
        return label
    }
    var passLabel:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(25, 230+25, 100, 50)
        label.text = "Password"
        label.textAlignment = .Right
        label.textColor = globalStyle.backgroundColor
        label.font = globalStyle.nameTitleFont
        return label
    }
    
    //    var alertLabel:UILabel{
    //        let label = UILabel()
    //        label.frame = CGRectMake(12.5, 200, globalStyle.screenSize.width-25, 25)
    //        label.textAlignment = .Center
    //        label.textColor = globalStyle.alertColor
    //        label.font = globalStyle.dateTitleFont
    //        label.text = "Email Addresss or Password can't be Empty"
    //
    //        return label
    //    }
    
    
    var creatAccount:UIButton{
        let button = UIButton()
        button.frame = CGRectMake(12.5, globalStyle.screenSize.height-50, globalStyle.screenSize.width-25, 50)
        //button.backgroundColor = globalStyle.backgroundColor
        
        
        let starAttr = NSMutableAttributedString(string:"Don't have an account? ")// Get helps with singing in
        starAttr.addAttribute(NSForegroundColorAttributeName, value:globalStyle.subTitleColor2, range: NSMakeRange(0,starAttr.length))
        starAttr.addAttribute(NSFontAttributeName, value: globalStyle.dateTitleFont!, range: NSMakeRange(0,starAttr.length))
        
        let secAttr = NSMutableAttributedString(string:"Sign Up")//
        secAttr.addAttribute(NSForegroundColorAttributeName, value:UIColor.blackColor(), range: NSMakeRange(0,secAttr.length))
        secAttr.addAttribute(NSFontAttributeName, value: globalStyle.subTitleMediumFontsize!, range: NSMakeRange(0,secAttr.length))
        
        starAttr.appendAttributedString(secAttr)

        button.addTarget(self, action: #selector(self.acountRegister), forControlEvents: UIControlEvents.TouchUpInside)
        button.setAttributedTitle(starAttr, forState: UIControlState.Normal)

        return button
    }
    
    var loggIn:UIButton{
        let button = UIButton()
        button.frame = CGRectMake(12.5, 305+25, globalStyle.screenSize.width-25, 50)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = globalStyle.backgroundColor.CGColor
        button.backgroundColor = UIColor.clearColor()
//        button.tintColor = globalStyle.backgroundColor
        
        button.setTitle("Login", forState: UIControlState.Normal)
        button.setTitleColor(globalStyle.backgroundColor, forState: .Normal)
        button.titleLabel?.textColor = globalStyle.backgroundColor
        button.titleLabel?.font = globalStyle.subTitleFontsize
        button.layer.cornerRadius = 6.0
        button.addTarget(self, action: #selector(self.authSubmit), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    var inputContainer:UILabel{
        let label = UILabel()
        label.frame = CGRectMake(12.5, 180+25, globalStyle.screenSize.width-25, 100)
        label.layer.borderWidth = 1.0
        label.layer.borderColor = globalStyle.backgroundColor.CGColor
        label.layer.cornerRadius = 6.0
        return label

    }
    
    var forgetPass:UIButton{
        let forget = UIButton()
        
        let starAttr = NSMutableAttributedString(string:"Forgotten your login details? ")// Get helps with singing in
        starAttr.addAttribute(NSForegroundColorAttributeName, value:globalStyle.subTitleColor2, range: NSMakeRange(0,starAttr.length))
        starAttr.addAttribute(NSFontAttributeName, value: globalStyle.dateTitleFont!, range: NSMakeRange(0,starAttr.length))
        
        let secAttr = NSMutableAttributedString(string:"Get helps with singing in")//
        secAttr.addAttribute(NSForegroundColorAttributeName, value:UIColor.blackColor(), range: NSMakeRange(0,secAttr.length))
        secAttr.addAttribute(NSFontAttributeName, value: globalStyle.subTitleMediumFontsize!, range: NSMakeRange(0,secAttr.length))
        
        starAttr.appendAttributedString(secAttr)

        forget.frame = CGRectMake(12.5, 405-25, globalStyle.screenSize.width-25, 25)
        forget.setAttributedTitle(starAttr, forState: UIControlState.Normal)

        return forget
        
    }
    
    
    var FBLogin:FBSDKLoginButton{
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        button.frame = CGRectMake(12.5, 405+50, globalStyle.screenSize.width-25, 50)
        button.tintColor = UIColor.whiteColor()
        button.titleLabel?.font = globalStyle.subTitleFontsize
        button.setTitle("Log in with Facebook", forState: UIControlState.Normal)
        button.delegate = self
        //button.addTarget(self, action: #selector(self.acountRegister), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }

    var FBProcessing = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        alertLabel.alpha = 0.0;
        alertLabel.textAlignment = .Center
        alertLabel.textColor = globalStyle.alertColor
        alertLabel.font = globalStyle.subTitleFontsize
        
        indicator.color = globalStyle.subTitleColor3
        indicator.frame = CGRectMake(12.5, 280+25, globalStyle.screenSize.width-50, 25)
        //        orlabel.layer.addBorder(UIRectEdge.Top, color: globalStyle.backgroundColor, thickness: 0.5)
//        orlabel.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: 0.5)
        orText.text = "or"
        orText.textAlignment = .Center
        orText.center.x = self.view.center.x
        orText.center.y = line.frame.origin.y
        orText.sizeToFit()
        orText.frame = CGRectMake(orText.center.x-25 ,line.frame.origin.y-12.5,25, 25)
        orText.backgroundColor = UIColor.whiteColor()
        orText.font = globalStyle.dateTitleFont
        orText.textColor = globalStyle.subTitleColor4
        self.view.addSubview(indicator)
        

        self.view.addSubview(userNameInput)
        self.view.addSubview(userPassInput)
        self.view.addSubview(emailLabel)
        self.view.addSubview(passLabel)
        self.view.addSubview(creatAccount)
        self.view.addSubview(loggIn)
        self.view.addSubview(line)
        self.view.addSubview(alertLabel)
        self.view.addSubview(inputContainer)
        self.view.addSubview(logo)
        self.view.addSubview(orText)
        self.view.addSubview(forgetPass)
        self.view.addSubview(FBLogin)
//        orlabel.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-12.5-[v5]-12.5-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":orlabel]))
//        orlabel.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-405-[v5(<=1)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v5":orlabel]))
        FBLogin.delegate = self
        FBLogin.addTarget(self, action: #selector(loginButton), forControlEvents: UIControlEvents.EditingChanged)
        userNameInput.delegate = self
        userPassInput.delegate = self
        userNameInput.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        userPassInput.addTarget(self, action: #selector(LoginViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
//        userNameInput.placeholder = "Your Email"
//        userPassInput.placeholder = "Your Password"
        userPassInput.font = globalStyle.nameTitleFont
        userNameInput.font = globalStyle.nameTitleFont
        userNameInput.layer.addBorder(UIRectEdge.Bottom, color: globalStyle.backgroundColor, thickness: 1.0)
        //userNameInput.round(UIRectCorner.TopLeft.union(.TopRight), radius: 6.0, borderColor: globalStyle.backgroundColor, borderWidth: 1)
        //userPassInput.round(UIRectCorner.BottomLeft.union(.BottomRight), radius: 6.0, borderColor: globalStyle.backgroundColor, borderWidth: 1)
        userNameInput.keyboardType = UIKeyboardType.EmailAddress
        userNameInput.returnKeyType = UIReturnKeyType.Next
        userNameInput.leftView = UIView(frame: CGRectMake(0, 0, 120, 50))
        userNameInput.leftViewMode = UITextFieldViewMode.Always
        userPassInput.secureTextEntry = true
        userPassInput.returnKeyType = UIReturnKeyType.Continue
        userPassInput.leftView = UIView(frame: CGRectMake(0, 0, 120, 50))
        userPassInput.leftViewMode = UITextFieldViewMode.Always
        //
        if let token = FBSDKAccessToken.currentAccessToken(){
            //
            //Already login
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarView") as! CustomUITabBarController
            let appDelgate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelgate.window?.rootViewController = tabBarController

            
            
        }
    }
    override func viewWillAppear(animated: Bool) {
        if(FBProcessing == true){
            self.loggIn.enabled = false
            self.loggIn.setTitle("Logining", forState:.Normal)
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //        let nextTage=textField.tag+1;
        //        // Try to find next responder
        //        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder!
        //
        if (textField == userNameInput){
            // Found next responder, so set it.
            userPassInput.becomeFirstResponder()
        }
        else
        {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
        return false // We do not want UITextField to insert line-breaks.
    }
    
    //
    func textFieldDidChange(textField: UITextField){
        
        
    }
    
    
    
    func authSubmit(sender:UIButton)->Void{
        if(userNameInput.text == "" || userPassInput.text == ""){
            alertLabel.alpha = 1.0
            alertLabel.text = "Email Addresss or Password can't be Empty"
            alertLabel.layer.addAnimation(help.alertLabelAnimator(alertLabel), forKey: "position")
            return
        }
        alertLabel.alpha = 0.0
        self.indicator.startAnimating()
        if(lock == false){
            self.lock = true
            Alamofire.request(.POST, self.loginBaseUrl,parameters: ["username": userNameInput.text!,"password":userPassInput.text!]).validate().responseJSON{response in
                switch response.result {
                case .Success(let data):
                    let json = JSON(data)
                    if(json == true){
                        self.indicator.stopAnimating()
                        
                        let activeUser = NSUserDefaults.standardUserDefaults()
                        activeUser.setObject(self.userNameInput.text!, forKey: "ActiveUser")
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarView") as! CustomUITabBarController
                        let appDelgate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelgate.window?.rootViewController = tabBarController
                    }
                    else if (json == false){
                        self.indicator.stopAnimating()
                        self.alertLabel.alpha = 1.0
                        self.alertLabel.text = "Wrong PassWord or Email Address"
                        self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                    }
                case .Failure(let error):
                    self.indicator.stopAnimating()
                    self.alertLabel.alpha = 1.0
                    self.alertLabel.text = String(error)
                    self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                    print("Request failed with error: \(error)")
                }
                self.lock = false
            }
        }
        return
    }
    
    func acountRegister(){
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerController = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterView") as! RegisterViewController
        self.navigationController!.pushViewController(registerController, animated: true)
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print(result)
        dataFetch.fetchFBProfile(){result in
            if let email = result!["email"] as? String{
                print(result!["email"])
                let firstName = result!["first_name"] as! String
                let lastName = result!["last_name"] as! String
                self.FBProcessing = true
                Alamofire.request(.POST, self.checkUserExistedBaseUrl,parameters: ["username": email]).validate().responseJSON{response in
                    switch response.result {
                    case .Success(let data):
                        let json = JSON(data)
                        if(json == true){//Username existed
                            let activeUser = NSUserDefaults.standardUserDefaults()
                            activeUser.setObject(email, forKey: "ActiveUser")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let tabBarController = storyboard.instantiateViewControllerWithIdentifier("tabBarView") as! CustomUITabBarController
                            let appDelgate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelgate.window?.rootViewController = tabBarController
                        }
                        else{
                            let registerController = self.storyboard!.instantiateViewControllerWithIdentifier("RegisterView") as! RegisterViewController
                            registerController.isFBLogin = true
                            registerController.firstNameInput.text = firstName
                            registerController.lastNameInput.text = lastName
                            registerController.emailInput.text = email
                            registerController.passInput.text = ""
                            if let avatar = result!["picture"] as? NSDictionary, data = avatar["data"] as? NSDictionary,avatarUrl = data["url"] as? String{
                                registerController.avatar_url = avatarUrl
                            }
                            self.navigationController!.pushViewController(registerController, animated: true)
                        }
                    case .Failure(let error):
                        self.indicator.stopAnimating()
                        self.alertLabel.alpha = 1.0
                        self.alertLabel.text = String(error)
                        self.alertLabel.layer.addAnimation(help.alertLabelAnimator(self.alertLabel), forKey: "position")
                        print("Network Request failed with error: \(error)")
                        self.lock = false
                    }
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
       
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}
extension UITextField {
    
    /**
     Rounds the given set of corners to the specified radius
     
     - parameter corners: Corners to round
     - parameter radius:  Radius to round to
     */
    override func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners, radius: radius)
    }
    
    /**
     Rounds the given set of corners to the specified radius with a border
     
     - parameter corners:     Corners to round
     - parameter radius:      Radius to round to
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    override func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners, radius: radius)
        addBorder(mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    /**
     Fully rounds an autolayout view (e.g. one with no known frame) with the given diameter and border
     
     - parameter diameter:    The view's diameter
     - parameter borderColor: The border color
     - parameter borderWidth: The border width
     */
    override func fullyRound(diameter: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        layer.masksToBounds = true
        layer.cornerRadius = diameter / 2
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.CGColor;
    }
    
}

private extension UITextField {
    
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