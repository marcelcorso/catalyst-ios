//
//  FBAuthViewController.swift
//  Catalyst
//
//  Created by Vincent Onderwaater on 15-09-15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import SwiftyJSON

class FBAuthViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    @IBAction func dismissButtonTouched(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if result.token != nil {
            
            let request = FBSDKGraphRequest(graphPath: "me?fields=id,name,picture.type(large)", parameters: [:]).startWithCompletionHandler { (connection, result, error) -> Void in
                
                if error != nil {
                    println(error)
                } else {
                    if let id = result["id"] as? String,
                        name = result["name"] as? String,
                        pictureData = result["picture"] as? [String: AnyObject],
                        picture = pictureData["data"] as? [String : AnyObject],
                        url = picture["url"] as? String
                    {
                        let userDict = ["avatar": url,
                            "facebook_id": id,
                            "name": name]
                        
                        let ref = Firebase(url:firebaseURL + "/users/" + id)
                        ref.setValue(userDict)
                        
                        NSUserDefaults.standardUserDefaults().setObject(id, forKey: "id")
                        self.dismissViewControllerAnimated(true, completion: nil)
                        
                    }
                }
            }
            
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        
        return true
    }
    
}
