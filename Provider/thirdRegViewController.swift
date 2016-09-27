//
//  thirdRegViewController.swift
//  Provider
//
//  Created by imac on 31/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class thirdRegViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var inputCollection = [customUITextField]()
    let indicator = UIActivityIndicatorView()
    var lock = false
    var scrollView = UIScrollView()
    var activeField: UITextField?
    var skillDescript = String()
    let imagePicker = UIImagePickerController()
    var galleryView = [UIImageView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Last Step"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        imagePicker.delegate = self
        // Do any additional setup after loading the view.
        //        print(skillDescript)
        //        for value in inputCollection {
        //            print(value.text)
        //        }
        
        self.registerForKeyboardNotifications()
        self.scrollView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
        self.scrollView.scrollEnabled = true;
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
        self.view.addSubview(scrollView)
        
        let initialUploaderBTN = self.createUploadButton(CGRectMake(12.5, 50, self.view.bounds.size.width/2-25, self.view.bounds.size.width/2-25))
        self.scrollView.addSubview(initialUploaderBTN)
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
    func createUploadButton(position:CGRect) -> UIButton{
        let button = UIButton(frame:position)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = globalStyle.subTitleColor4.CGColor
        button.layer.cornerRadius = 6.0
        button.setImage(UIImage(named: "uploader.png"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(self.uploader), forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //    func createImgView(<#parameters#>) -> <#return type#> {
    //        <#function body#>
    //    }
    func uploader(sender:UIButton){
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let imageView = UIImageView()
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: Keyboard function
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if activeField != nil
        {
            if (!CGRectContainsPoint(aRect, activeField!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        let info : NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(75, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
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
}
