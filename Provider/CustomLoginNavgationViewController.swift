//
//  CustomLoginNavgationViewController.swift
//  Provider
//
//  Created by imac on 28/08/16.
//  Copyright © 2016 newnergy. All rights reserved.
//

import UIKit

class CustomLoginNavgationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barTintColor = globalStyle.backgroundColor2

        UIApplication.sharedApplication().statusBarStyle = .LightContent
        // Do any additional setup after loading the view.
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

}
