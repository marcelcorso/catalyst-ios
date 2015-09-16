//
//  ViewController.swift
//  Catalyst
//
//  Created by Corné Driesprong on 15/09/15.
//  Copyright (c) 2015 YoloAmazeballzInterwebs. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import SDWebImage

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var pairView: UIView!
    @IBOutlet weak var codeEntryTextField: UITextField!
    @IBOutlet weak var userProfilePicture: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = UIRectEdge.None
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        
        connectButton.layer.cornerRadius = 8.0
        connectButton.layer.borderColor = UIColor.darkGrayColor().CGColor
        connectButton.layer.borderWidth = 1.0
        
        userProfilePicture.layer.cornerRadius = userProfilePicture.bounds.height / 2
        userProfilePicture.layer.masksToBounds = true
        
        let myName = NSUserDefaults.standardUserDefaults().objectForKey("name") as! String
        userNameLabel.text = myName
        
        let myId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        let ref = Firebase(url:"https://catalysttv.firebaseio.com/users/\(myId)")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let person = snapshot.value {
                
                let url = person.objectForKey("avatar") as! String
                SDWebImageManager.sharedManager().downloadImageWithURL(NSURL(string: url), options: nil, progress: nil) { (image, error, imageCacheType, finished, url) -> Void in
                    
                    if image != nil {
                        self.userProfilePicture.image = image
                    }
                }
            }
        })
    }
    
    func keyboardDidShow(notification: NSNotification) {
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.pairView.frame.origin = CGPoint(x: self.pairView.frame.origin.x, y: 100)
            self.userNameLabel.alpha = 0
            self.userProfilePicture.alpha = 0
            self.messageLabel.alpha = 0
        })
    }

    @IBAction func connectButtonTapped(sender: AnyObject) {
        let id = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
        
        
        if let associatedCode = codeEntryTextField.text as? String where count(associatedCode) > 0 {
            
            let ref = Firebase(url:firebaseURL + "/code2userid/" + self.codeEntryTextField.text)
            
            ref.setValue(id, withCompletionBlock: { (error: NSError!, firebase: Firebase!) -> Void in
                
                if error == nil {
                let userId = NSUserDefaults.standardUserDefaults().objectForKey("id") as! String
                self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                
                    self.connectButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
                    self.connectButton.setTitle("ERROR! Try again", forState: .Normal)
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), { () -> Void in
                        self.connectButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                        self.connectButton.setTitle("Connect", forState: .Normal)
                    })
                }
                
                
            })
            
        } else {
        
            print("CAN'T SET AN EMPTY CODE!")
        }
        
        // TODO: check if entry dissapears
    }
}

